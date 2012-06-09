class NSArray
  def to_ip
    NSIndexPath.indexPathForRow(self[1], inSection:self[0])
  end
end
