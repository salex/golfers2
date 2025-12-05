module Things
  class RatePlaces
    attr_accessor :winners, :purse, :places_paid
    # include Things::Utilities
    include PlacesHelper


    def initialize(numb_players,dues,doll=nil)
      @dues = dues.to_f
      puts "DOLL #{doll.present?}"
      @purse = numb_players * @dues 
      @places_paid = numb_players / 2
      # @rate = Exonio.rate(9, 6,0, -108)
      if places_paid == 2
        @winners = [(purse*0.4),(purse*0.6)]
      else
        @rate = Exonio.rate(@places_paid, @dues,0, -@purse)
        @winners = [@dues]
        1.upto(@places_paid - 1) do |w|
          @winners[w] = ((1 + @rate ) * (winners[w-1]))
        end
      end
      # puts "WINNERS NP #{doll} #{winners.reverse} #{@purse}"
      # dollarize(@winners,@purse)
      if doll.present?
        dollarize(@winners,@purse)
      else
        quarterize(@winners,@purse)
      end


    end

    def round_to_quarters(num)
      amt = ((num * 4).to_i / 0.25 / 4) * 0.25
    end

  end
end
