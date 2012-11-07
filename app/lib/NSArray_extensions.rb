class NSArray
  def to_ip
    NSIndexPath.indexPathForRow(self[1], inSection:self[0])
  end

  def mean
    return 0 unless size > 0
    
    reduce(:+).to_f / size
  end

  def to_json
    json = self.collect {|e| e.to_json_raw}
    
    error_ptr = Pointer.new(:object)  
    unless data = NSJSONSerialization.dataWithJSONObject(json, options:NSJSONWritingPrettyPrinted, error:error_ptr)
      raise "Error when fetching data: #{error_ptr[0].description}"
    end
    NSString.alloc.initWithData(data, encoding:NSUTF8StringEncoding)
  end  
end