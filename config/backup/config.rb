# encoding: utf-8

# usage: Launch in command line
# backup perform --config-file <path_to_this_file> --trigger group_webapp

Dir[File.join(File.dirname(Config.config_file), "models", "*.rb")].each do |model|
  instance_eval(File.read(model))
end
