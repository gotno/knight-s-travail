class TreeNode
  attr_reader :children
  attr_accessor :parent, :value

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def add_child(child_node)
    @children << child_node
    child_node.parent = self
  end

  def remove_child(child_node)
    @children.delete(child_node)
    child_node.parent = nil
  end

  def dfs(target_value)
    return self if self.value == target_value

    @children.each do |child|
      node = child.dfs(target_value)
      return node if node
    end

    nil
  end

  def bfs(target_value)
    queue = [self]

    until queue.empty?
      candidate_node = queue.shift
      return candidate_node if candidate_node.value == target_value

      candidate_node.children.each { |child| queue << child }
    end
  end
end
