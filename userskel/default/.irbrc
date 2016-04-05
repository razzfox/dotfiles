require 'rubygems'
require 'brice/init'  # equivalent to: require 'brice'; Brice.init
require 'bond'

Bond.start



def re_execute(start, stop=nil)
    stop=start unless stop
    code = history_a[start..stop]
    code.each_with_index { |e,i|
        irb_context.evaluate(e,i)
    }
    Readline::HISTORY.pop
    code.each { |l|
        Readline::HISTORY.push l
    }
    puts code
end

def loop_execute(file)
  old_mtime = nil
  loop do
    # print("\e[sWaiting...")
    sleep(0.2) while (mtime = File.stat(file).mtime) == old_mtime
    # print("\e[u\e[K")
    begin
      r = eval(File.read(file))
      puts("=> #{r.inspect}")
    rescue IRB::Abort
      puts("Abort")
      return
    rescue Exception => e
      puts("#{e.class}: #{e.message}\n#{e.backtrace.join("\n")}")
    end
    old_mtime = mtime
  end
end



def colputs(array)
  def num_columns; 4; end
  def col_width; 25; end
  def force_length(x)
    x = x.to_s
    max_length = col_width+2
    if x.length > max_length
      x = x[0..max_length-4] + '...'
    end
    x += (' '*max_length)
    x[0..max_length-1]
  end
  def get_element(array, i) # displays in column order instead of row order
    num_rows = (array.length/num_columns)+1
    col = i % num_columns
    row = i / num_columns
    array[col*num_rows+row]
  end
  for i in (0..array.length)
    print force_length(get_element(array, i))
    print "  "
    puts if (i % num_columns) == (num_columns-1)
  end
  nil
end

class Object
  # Return only the methods not present on basic objects
  def show_methods
    colputs (self.methods - Object.new.methods).sort
  end
end
