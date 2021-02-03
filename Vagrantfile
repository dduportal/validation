Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 2
    v.check_guest_additions = false
  end
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.define "production" do |node|
    node.vm.box = "ubuntu/focal64"
  end

  config.vm.define "jenkins" do |node|
    node.vm.box = "ubuntu/focal64"
  end

  config.vm.define "jenkins-agent" do |node|
    node.vm.box = "ubuntu/focal64"
  end
end
