class Stratego
  STARTING_PIECES = {
    marshal: 10,
    general: 1,
    colonel: 2,
    major: 3,
    captain: 4,
    lieutenant: 4,
    sergeant: 4,
    miner: 5,
    scout: 8,
    spy: 1,
    bomb: 6,
    flag: 1
  }

  DEFEATS = {
    marshal: [:general, :colonel, :major, :captain, :lieutenant, :sergeant, :miner, :scout, :spy],
    general: [:colonel, :major, :captain, :lieutenant, :sergeant, :miner, :scout, :spy],
    colonel: [:major, :captain, :lieutenant, :sergeant, :miner, :scout, :spy],
    major: [:captain, :lieutenant, :sergeant, :miner, :scout, :spy],
    captain: [:lieutenant, :sergeant, :miner, :scout, :spy],
    lieutenant: [:sergeant, :miner, :scout, :spy],
    sergeant: [:miner, :scout, :spy],
    miner: [:scout, :spy, :bomb],
    scout: [:spy],
    spy: [:marshal],
    bomb: [],
    flag: []
  }

  def initialize
    @board = [nil] * 100

    @pieces = {
      red: STARTING_PIECES.dup,
      blue: STARTING_PIECES.dup
    }
  end

  def place x, y, color, rank
    return unless @pieces[color][rank] > 0
    @pieces[color][rank]--

    index = x + y * 10

    if @board[index].nil?
      @board[index] = { color: color, rank: rank }
    end
  end

  def valid_move? x1, y1, x2, y2
    piece = @board[x1 + y1 * 10]

    return false unless piece

    case piece[:rank]
    when :bomb, :flag
      false
    when :scout
      # TODO: check for collisions
      x1 == x2 || y1 == y2
    else
      (x1 == x2 && (y1 - y2).abs == 1) || (y1 == y2 && (x1 - x2).abs == 1)
    end
  end

  def move x1, y1, x2, y2
    return unless valid_move? x1, y1, x2, y2

    start_index = x1 + y1 * 10
    end_index = x2 + y2 * 10

    start_piece = @board[start_index]
    end_piece = @board[end_index]

    if end_piece.nil?
      @board[end_index] = @board[start_index]
      @board[start_index] = nil
    elsif start_piece[:color] != end_piece[:color]
      if start_piece[:rank] == end_piece[:rank]
        puts "both pieces removed"
        @board[end_index] = nil
      elsif DEFEATS[start_piece[:rank]].include? end_piece[:rank]
        puts "#{start_piece[:rank]} defeats #{end_piece[:rank]}"
        @board[end_index] = start_piece
      else
        puts "#{start_piece[:rank]} does not defeat #{end_piece[:rank]}"
      end

      @board[start_index] = nil
    end
  end

  def print
    output = ""

    10.times do |y|
      10.times do |x|
        piece = @board[x + y * 10]
        if piece
          color = piece[:color] == :red ? "R" : "B"
          rank = case piece[:rank]
                 when :marshal
                   "1"
                 when :general
                   "2"
                 when :colonel
                   "3"
                 when :major
                   "4"
                 when :captain
                   "5"
                 when :lieutenant
                   "6"
                 when :sergeant
                   "7"
                 when :miner
                   "8"
                 when :scout
                   "9"
                 when :spy
                   "S"
                 when :bomb
                   "B"
                 when :flag
                   "F"
                 end
          output += " #{color}#{rank}"
        else
          output += " --"
        end
      end

      output += "\n"
    end

    puts output
  end
end
