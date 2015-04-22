module Git
  class Lib
    def command_proxy(cmd, opts = [], chdir = true, redirect = '', &block)
      command(cmd, opts, chdir, redirect, &block)
    end
  end
end
