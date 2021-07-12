# frozen_string_literal: true
module Stupidedi
  using Refinements

  class Config
    autoload :CodeListConfig,         "stupidedi/config/code_list_config"
    autoload :EditorConfig,           "stupidedi/config/editor_config"
    autoload :FunctionalGroupConfig,  "stupidedi/config/functional_group_config"
    autoload :InterchangeConfig,      "stupidedi/config/interchange_config"
    autoload :TransactionSetConfig,   "stupidedi/config/transaction_set_config"

    include Inspect

    # @return [InterchangeConfig]
    attr_reader :interchange

    # @return [FunctionalGroupConfig]
    attr_reader :functional_group

    # @return [TransactionSetConfig]
    attr_reader :transaction_set

    # @return [CodeListConfig]
    attr_reader :code_list

    # @return [EditorConfig]
    attr_reader :editor

    def initialize
      @interchange      = InterchangeConfig.new
      @functional_group = FunctionalGroupConfig.new
      @transaction_set  = TransactionSetConfig.new
      @code_list        = CodeListConfig.new
      @editor           = EditorConfig.new
    end

    def customize(&block)
      tap(&block)
    end

    # @return [void]
    def pretty_print(q)
      q.text "Config"
      q.group 2, "(", ")" do
        q.breakable ""

        q.pp @interchange
        q.text ","
        q.breakable

        q.pp @functional_group
        q.text ","
        q.breakable

        q.pp @transaction_set
        q.text ","
        q.breakable

        q.pp @code_list
        q.text ","
        q.breakable

        q.pp @editor
      end
    end
  end

  class << Config
    ###########################################################################
    # @group Constructors

    # @return [Config]
    def default
      new.customize do |c|
        c.interchange.customize do |x|
          x.register("00200") { Stupidedi::Interchanges::TwoHundred::InterchangeDef }
          x.register("00300") { Stupidedi::Interchanges::ThreeHundred::InterchangeDef }
          x.register("00400") { Stupidedi::Interchanges::FourHundred::InterchangeDef }
          x.register("00401") { Stupidedi::Interchanges::FourOhOne::InterchangeDef }
          x.register("00501") { Stupidedi::Interchanges::FiveOhOne::InterchangeDef }
        end

        c.functional_group.customize do |x|
          x.register("002001") { Stupidedi::Versions::TwoThousandOne::FunctionalGroupDef }
          x.register("003010") { Stupidedi::Versions::ThirtyTen::FunctionalGroupDef }
          x.register("003040") { Stupidedi::Versions::ThirtyForty::FunctionalGroupDef }
          x.register("003050") { Stupidedi::Versions::ThirtyFifty::FunctionalGroupDef }
          x.register("004010") { Stupidedi::Versions::FortyTen::FunctionalGroupDef }
          x.register("005010") { Stupidedi::Versions::FiftyTen::FunctionalGroupDef }
        end
      end
    end

    def hipaa(base = default)
      base.customize do |c|
        c.transaction_set.customize do |x|
          x.register("004010",       "HP", "835") { Stupidedi::TransactionSets::FortyTen::Standards::HP835 }
          x.register("004010X091A1", "HP", "835") { Stupidedi::TransactionSets::FortyTen::Implementations::X091A1::HP835 }

          x.register("005010",       "HR", "276") { Stupidedi::TransactionSets::FiftyTen::Standards::HR276 }
          x.register("005010",       "HN", "277") { Stupidedi::TransactionSets::FiftyTen::Standards::HN277 }
          x.register("005010",       "BE", "834") { Stupidedi::TransactionSets::FiftyTen::Standards::BE834 }
          x.register("005010",       "HP", "835") { Stupidedi::TransactionSets::FiftyTen::Standards::HP835 }
          x.register("005010",       "HC", "837") { Stupidedi::TransactionSets::FiftyTen::Standards::HC837 }
          x.register("005010",       "FA", "997") { Stupidedi::TransactionSets::FiftyTen::Standards::FA997 }
          x.register("005010",       "FA", "999") { Stupidedi::TransactionSets::FiftyTen::Standards::FA999 }
          x.register("005010",       "RA", "820") { Stupidedi::TransactionSets::FiftyTen::Standards::RA820 }
          x.register("005010X212",   "HR", "276") { Stupidedi::TransactionSets::FiftyTen::Implementations::X212::HR276 }
          x.register("005010X212",   "HN", "277") { Stupidedi::TransactionSets::FiftyTen::Implementations::X212::HN277 }
          x.register("005010X214",   "HN", "277") { Stupidedi::TransactionSets::FiftyTen::Implementations::X214::HN277 }
          x.register("005010X220",   "BE", "834") { Stupidedi::TransactionSets::FiftyTen::Implementations::X220::BE834 }
          x.register("005010X221",   "HP", "835") { Stupidedi::TransactionSets::FiftyTen::Implementations::X221::HP835 }
          x.register("005010X222",   "HC", "837") { Stupidedi::TransactionSets::FiftyTen::Implementations::X222::HC837 }
          x.register("005010X223",   "HC", "837") { Stupidedi::TransactionSets::FiftyTen::Implementations::X223::HC837 }
          x.register("005010X231",   "FA", "999") { Stupidedi::TransactionSets::FiftyTen::Implementations::X231::FA999 }
          x.register("005010X279",   "HS", "270") { Stupidedi::TransactionSets::FiftyTen::Implementations::X279::HS270 }
          x.register("005010X279",   "HB", "271") { Stupidedi::TransactionSets::FiftyTen::Implementations::X279::HB271 }
          x.register("005010X220A1", "BE", "834") { Stupidedi::TransactionSets::FiftyTen::Implementations::X220A1::BE834 }
          x.register("005010X221A1", "HP", "835") { Stupidedi::TransactionSets::FiftyTen::Implementations::X221A1::HP835 }
          x.register("005010X222A1", "HC", "837") { Stupidedi::TransactionSets::FiftyTen::Implementations::X222A1::HC837 }
          x.register("005010X223A1", "HC", "837") { Stupidedi::TransactionSets::FiftyTen::Implementations::X223A1::HC837 }
          x.register("005010X231A1", "FA", "999") { Stupidedi::TransactionSets::FiftyTen::Implementations::X231A1::FA999 }
          x.register("005010X279A1", "HS", "270") { Stupidedi::TransactionSets::FiftyTen::Implementations::X279A1::HS270 }
          x.register("005010X279A1", "HB", "271") { Stupidedi::TransactionSets::FiftyTen::Implementations::X279A1::HB271 }
          x.register("005010X223A2", "HC", "837") { Stupidedi::TransactionSets::FiftyTen::Implementations::X223A2::HC837 }
          x.register("005010X223A3", "HC", "837") { Stupidedi::TransactionSets::FiftyTen::Implementations::X223A3::HC837 }

          x.register("005010X217",   "HI", "278") { Stupidedi::TransactionSets::FiftyTen::Standards::HI278 }
          x.register("005010X218",   "RA", "820") { Stupidedi::TransactionSets::FiftyTen::Standards::RA820 }
          x.register("005010X224",   "HC", "837") { Stupidedi::TransactionSets::FiftyTen::Standards::HC837 }
          x.register("005010X224A1", "HC", "837") { Stupidedi::TransactionSets::FiftyTen::Standards::HC837 }
          x.register("005010X224A2", "HC", "837") { Stupidedi::TransactionSets::FiftyTen::Standards::HC837 }
          x.register("005010X230",   "FA", "997") { Stupidedi::TransactionSets::FiftyTen::Standards::FA997 }
          x.register("005010X291",   "HC", "837") { Stupidedi::TransactionSets::FiftyTen::Standards::HC837 }
          x.register("005010X292",   "HC", "837") { Stupidedi::TransactionSets::FiftyTen::Standards::HC837 }
          x.register("005010X298",   "HC", "837") { Stupidedi::TransactionSets::FiftyTen::Standards::HC837 }
          x.register("005010X306",   "RA", "820") { Stupidedi::TransactionSets::FiftyTen::Standards::RA820 }
          x.register("005010X307",   "BE", "834") { Stupidedi::TransactionSets::FiftyTen::Standards::BE834 }
        end
      end
    end

    def contrib(base = default)
      base.customize do |c|
        c.transaction_set.customize do |x|
          x.register("002001", "SH", "856") { Stupidedi::TransactionSets::TwoThousandOne::Standards::SH856 }
          x.register("002001", "PO", "830") { Stupidedi::TransactionSets::TwoThousandOne::Standards::PO830 }
          x.register("002001", "FA", "997") { Stupidedi::TransactionSets::TwoThousandOne::Standards::FA997 }
          x.register("003010", "RA", "820") { Stupidedi::TransactionSets::ThirtyTen::Standards::RA820 }
          x.register("003010", "PO", "850") { Stupidedi::TransactionSets::ThirtyTen::Standards::PO850 }
          x.register("003010", "PC", "860") { Stupidedi::TransactionSets::ThirtyTen::Standards::PC860 }
          x.register("003010", "PS", "830") { Stupidedi::TransactionSets::ThirtyTen::Standards::PS830 }
          x.register("003040", "WA", "142") { Stupidedi::TransactionSets::ThirtyForty::Standards::WA142 }
          x.register("003050", "PO", "850") { Stupidedi::TransactionSets::ThirtyFifty::Standards::PO850 }
          x.register("004010", "PO", "850") { Stupidedi::TransactionSets::FortyTen::Standards::PO850 }
          x.register("004010", "IN", "810") { Stupidedi::TransactionSets::FortyTen::Standards::IN810 }
          x.register("004010", "PR", "855") { Stupidedi::TransactionSets::FortyTen::Standards::PR855 }
          x.register("004010", "OW", "940") { Stupidedi::TransactionSets::FortyTen::Standards::OW940 }
          x.register("004010", "AR", "943") { Stupidedi::TransactionSets::FortyTen::Standards::AR943 }
          x.register("004010", "RE", "944") { Stupidedi::TransactionSets::FortyTen::Standards::RE944 }
          x.register("004010", "SW", "945") { Stupidedi::TransactionSets::FortyTen::Standards::SW945 }
          x.register("004010", "SM", "204") { Stupidedi::TransactionSets::FortyTen::Standards::SM204 }
          x.register("004010", "QM", "214") { Stupidedi::TransactionSets::FortyTen::Standards::QM214 }
          x.register("004010", "IM", "210") { Stupidedi::TransactionSets::FortyTen::Standards::IM210 }
          x.register("004010", "GF", "990") { Stupidedi::TransactionSets::FortyTen::Standards::GF990 }
          x.register("004010", "SS", "862") { Stupidedi::TransactionSets::FortyTen::Standards::SS862 }
          x.register("004010", "PS", "830") { Stupidedi::TransactionSets::FortyTen::Standards::PS830 }
          x.register("004010", "SH", "856") { Stupidedi::TransactionSets::FortyTen::Standards::SH856 }
          x.register("004010", "SQ", "866") { Stupidedi::TransactionSets::FortyTen::Standards::SQ866 }
          x.register("004010", "FA", "997") { Stupidedi::TransactionSets::FortyTen::Standards::FA997 }
          x.register("004010", "SC", "832") { Stupidedi::TransactionSets::FortyTen::Standards::SC832 }
        end
      end
    end

    # @endgroup
    ###########################################################################
  end
end
