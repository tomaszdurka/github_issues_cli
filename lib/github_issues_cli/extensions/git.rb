module Git
  class Lib
    def command_proxy(cmd, opts = [], chdir = true, redirect = '', &block)
      puts cmd + opts.join(' ')
      command(cmd, opts, chdir, redirect, &block)
    end
  end
end
