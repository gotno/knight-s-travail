require_relative 'tree_node'

class KnightPathFinder
  attr_reader :tree

  MOVEMENT_DIFFS = [ [ 2,  1],
            [ 2, -1],
            [-2,  1],
            [-2, -1],
            [ 1,  2],
            [ 1, -2],
            [-1,  2],
            [-1, -2] ] 

  def initialize (coordinates)
    @coordinates = coordinates
    build_move_tree
  end

  def build_move_tree
    @tree = TreeNode.new(@coordinates)
    queue = [@tree]
    already_visited = [@tree.value]

    until queue.empty?
      working_node = queue.shift

      moves_one_away(working_node.value).each do |move|
        unless already_visited.include?(move)
          new_node = TreeNode.new(move)
          working_node.add_child(new_node)

          already_visited << new_node.value
          queue << new_node
        end
      end
    end
  end

  def moves_one_away(pos)
    moves = []
    MOVEMENT_DIFFS.each do |diff|
      new_move = [pos[0] + diff[0], pos[1] + diff[1]]
      moves << new_move if (new_move[0] >= 0 && new_move[0] <= 7) &&
                           (new_move[1] >= 0 && new_move[1] <= 7)
    end
    moves
  end

  def find_path(target_pos)
    @tree.bfs(target_pos)
  end

  def path(target_pos)
    target_node = find_path(target_pos)
    path = []

    while true
      path.unshift(target_node.value)
      break if target_node.parent.nil?

      target_node = target_node.parent
    end
    path
  end


  def render_path(target_pos)
    board = []
    8.times do |i|
      board[i] = []
      8.times do |j|
        board[i][j] = "."
        if i == target_pos[0] && j == target_pos[1]
          board[i][j] = "X"
        end
      end
    end

    path = self.path(target_pos)
    move_count = 0
    until path.empty?
      x, y = path.shift
      board[x][y] = "#{move_count}"
      render_board(board)
      move_count += 1
      sleep 0.4
    end
  end

  def render_board(board)
    system("clear")
    board.each do |row|
      row.each do |col|
        print col + " "
      end
      print "\n"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  kpf = KnightPathFinder.new([ARGV[0].to_i, ARGV[1].to_i])
  kpf.render_path([ ARGV[2].to_i, ARGV[3].to_i ])
end
