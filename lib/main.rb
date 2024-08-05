class Node
  attr_accessor :left, :right, :value

  def initialize(val=nil, left=nil, right=nil)
    @value = val
    @left = left
    @right = right
  end
end