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
    end

    EZ = Mod.new(1, 'Easy')
    NF = Mod.new(0, 'NoFail')
    HT = Mod.new(8, 'HalfTime')
    HR = Mod.new(4, 'HardRock')
    SD = Mod.new(5, 'SuddenDeath')
    PF = Mod.new(14, '+Perfect')
    DT = Mod.new(6, 'DoubleTime')
    NC = Mod.new(9, '+NightCore')
    HD = Mod.new(3, 'Hidden')
    FL = Mod.new(10, 'FlashLight')
    # Relax
    # AutoPilot
    SO = Mod.new(12, 'SpunOut')
    # Auto

    ModList = [EZ, NF, HT, HR, SD, PF, DT, NC, HD, FL, SO]

    class Mods
      include Enumerable

      def initialize(mods)
        @mods = mods
      end

      def include?(mod)
        @mods & mod.to_i != 0
      end

      def to_a
        ModList.select{|mod| include? mod}
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

