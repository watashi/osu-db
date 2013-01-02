module Osu
  module DB
    class Mod
      def initialize(index, name)
        @index = index
        @name = name
      end

      def to_i
        1 << @index
      end

      def to_s
        @name
      end

      # Easy
      EZ = Mod.new(1, 'Easy')
      # No Fail
      NF = Mod.new(0, 'NoFail')
      # Half Time
      HT = Mod.new(8, 'HalfTime')
      # Hard Rock
      HR = Mod.new(4, 'HardRock')
      # Sudden Death
      SD = Mod.new(5, 'SuddenDeath')
      # Perfect (based on SD)
      PF = Mod.new(14, '+Perfect')
      # Double Time
      DT = Mod.new(6, 'DoubleTime')
      # Night Core (based on DT)
      NC = Mod.new(9, '+NightCore')
      # Hidden
      HD = Mod.new(3, 'Hidden')
      # Flash Light
      FL = Mod.new(10, 'FlashLight')
      # Relax
      RL = Mod.new(-1, 'Relax')
      # Auto Pilot
      AP = Mod.new(-1, 'AutoPilot')
      # Spun Out
      SO = Mod.new(12, 'SpunOut')
      # Auto

      # Return all ranked mods
      def self.all
        [EZ, NF, HT, HR, SD, PF, DT, NC, HD, FL, SO]
      end
    end

    class Mods
      include Enumerable

      def initialize(mods)
        @mods = mods
      end

      def include?(mod)
        @mods & mod.to_i != 0
      end

      def to_a
        Mod.all.select{|mod| include? mod}
      end

      def to_i
        @mods
      end

      def to_s
        to_a.map{|mod| mod.to_s} * ','
      end
    end
  end
end

