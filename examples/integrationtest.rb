#!/usr/bin/env ruby2.0
#
# This is a simple integraiton test performing some usefull server actions.
#
# This is also intended as some kind of documentation on how to use the library
#
#
require 'fog/hetznercloud'
require 'pp'

# Connecto to Hetznercloud
connection = Fog::Compute[:hetznercloud]

# Some variables
ssh_public_keyfile = "./keys/testkey.pub" # needs to be generated first with 'ssh-keygen -t rsa testkey'
ssh_private_keyfile = "./keys/testkey"    # needs to be generated first with 'ssh-keygen -t rsa testkey'
ssh_keyname = "testkey"                   # Name of the ssh key
servername = "testserver"                 # Name of the server

# resources created
image_snapshot = nil
image_backup = nil
server = nil
floating_ip = nil
ssh_key = nil

raise "Error: Fild #{ssh_private_keyfile} missing (create with 'ssh-keygen -t rsa -N \"\" -f #{ssh_private_keyfile}')" unless File.file?(ssh_private_keyfile)

begin

  # Lookups, see api doc https://docs.hetzner.cloud for filters
  connection.datacenters.each { |x| puts "Datacenter #{x.name} located in #{x.location.name}" }
  connection.locations.each { |x| puts "Location #{x.name} located in #{x.city}" }
  connection.locations.all(:name => 'fsn1').each { |x| puts "FSN Found" }
  connection.locations.all(:name => 'nbg1').each { |x| puts "NBG Found" }
  connection.server_types.each { |x| puts "Server Type #{x.name} (#{x.cores}/#{x.memory}/#{x.disk})" }
  connection.server_types.all(:name => 'cx11').each { |x| puts "Server cx11 found" }

  ## create or select ssh key ...
  ssh_key = connection.ssh_keys.all(:name => ssh_keyname).first
  if !ssh_key
    puts "Creating SSH Key ..."
    ssh_key = connection.ssh_keys.create(:name => ssh_keyname, :public_key => ssh_public_keyfile)
  else
    puts "Using existing SSH Key ..."
  end

  puts "Creating Floating IP"
  floating_ip = connection.floating_ips.create(:type => 'ipv4', :home_location => 'fsn1' )
  puts "Using existing VIP #{floating_ip.ip} #{floating_ip.server.nil? ? 'unbound' : 'assigned to' + floating_ip.server.name}"

  # lookup existing server by name or create new server, works with most resources
  server = connection.servers.all(:name => servername).first
  if !server
    puts "Bootstrapping Server (waiting until ssh is ready)..."
    server = connection.servers.bootstrap(
      :name => servername,
      :image => 'centos-7',
      :server_type => 'cx11',
      :location => 'nbg1',
      :user_data => "./userdata.txt",
      :private_key_path => ssh_private_keyfile,
      :ssh_keys => [ ssh_key.identity ],
      :bootstap_timeout => 120,
    )
  else
    puts "Using existing Server ... "
  end
  puts "Server public_ip_address:#{server.public_ip_address} (#{server.public_dns_name}/#{server.reverse_dns_name})"

  puts "Assign VIP #{floating_ip.ip} to #{server.name}"
  floating_ip.assign(server)

  # now wait for the server to boot
  puts "Waiting for Server SSH ..."
  server.wait_for {  server.sshable? }

  puts "Adding VIP to server"
  server.ssh("/sbin/ip addr add dev eth0 #{floating_ip.ip}")

  puts "Changing Root Password"
  action,password = server.reset_root_password
  puts "New Root password #{password}"

  puts "Unassigning VIP"
  floating_ip.unassign()

  puts "SSH in server ..."
  puts server.ssh('cat /tmp/test').first.stdout # => "test1\r\n"

  puts "Setting API to syncronous mode (wait for action to complete)"
  server.sync=true

  puts "Create Image (Sync) ..."
  action, image_snapshot = server.create_image()

  puts "Enable Backup ..."
  server.enable_backup

  puts "Create Backup (ASync) ..."
  action, image_backup = server.create_backup()

  puts "Disable Backup ..."
  server.enable_backup

  # Boot Server in rescue system with SSH Keys
  puts "Booting into rescue mode"
  server.enable_rescue(:ssh_keys => [ ssh_keyname ])
  server.reboot()
  server.wait_for { server.sshable?  }

  puts "SSH in Rescue System ..."
  puts server.ssh('hostname').first.stdout # => "test1\r\n"

  # Reboot again
  puts "Booting into normal mode"
  server.disable_rescue()
  server.reset()
  server.wait_for { server.sshable?  }

  # Change Server Type
  puts "Changing Server Type to cx21"
  server.shutdown()
  # FIXME: Handle in GEM, sometimes API error ?
  server.wait_for { server.stopped?  }
  server.change_type(:upgrade_disk => false, :server_type => 'cx21')
  server.poweron()
  server.wait_for { server.sshable?  }

  puts server.ssh('hostname').first.stdout # => "test1\r\n"

  # Change PTR
  puts "Changing PTR"
  server.change_dns_ptr('www.elconas.de')
  server.reload

  puts "PowerOff Server"
  server.poweroff

  puts "Setting API to asynchronous mode"
  server.async=true

  puts "Destroy Server ..."
  server.destroy
rescue Exception => e
  server.destroy unless server.nil?
  image_snapshot.destroy unless image_snapshot.nil?
  image_backup.destroy unless image_backup.nil?
  floating_ip.destroy unless floating_ip.nil?
  ssh_key.destroy unless ssh_key.nil?

  ## List Accounts
  connection.servers.each { |x|
    puts "Server #{x.id}: #{x.name} #{x.public_ip_address}"
  }
  connection.floating_ips.each { |x|
  	puts "Floating IP #{x.id}: #{x.ip}"
  }
  connection.images.all(:type => 'snapshot').each { |x|
  	puts "Snapshot Image #{x.id}: #{x.description}"
  }
  connection.images.all(:type => 'backup').each { |x|
  	puts "Backup Image #{x.id}: #{x.description}"
  }
  raise e
end
