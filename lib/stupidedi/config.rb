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
          #x.register("00200") { Stupidedi::Versions::Interchanges::FourOhOne::InterchangeDef }
          x.register("00200") { Stupidedi::Versions::Interchanges::TwoHundred::InterchangeDef }
          x.register("00300") { Stupidedi::Versions::Interchanges::ThreeHundred::InterchangeDef }
          x.register("00400") { Stupidedi::Versions::Interchanges::FourHundred::InterchangeDef }
          x.register("00401") { Stupidedi::Versions::Interchanges::FourOhOne::InterchangeDef }
          x.register("00501") { Stupidedi::Versions::Interchanges::FiveOhOne::InterchangeDef }
        end

        c.functional_group.customize do |x|
          # x.register("002001") { Stupidedi::Versions::FunctionalGroups::FortyTen::FunctionalGroupDef }
          x.register("002001") { Stupidedi::Versions::FunctionalGroups::TwoThousandOne::FunctionalGroupDef }
          x.register("003010") { Stupidedi::Versions::FunctionalGroups::ThirtyTen::FunctionalGroupDef }
          x.register("003040") { Stupidedi::Versions::FunctionalGroups::ThirtyForty::FunctionalGroupDef }
          x.register("003050") { Stupidedi::Versions::FunctionalGroups::ThirtyFifty::FunctionalGroupDef }
          x.register("004010") { Stupidedi::Versions::FunctionalGroups::FortyTen::FunctionalGroupDef }
          x.register("005010") { Stupidedi::Versions::FunctionalGroups::FiftyTen::FunctionalGroupDef }
        end
      end
    end

    def hipaa(base = default)
      base.customize do |c|
        c.transaction_set.customize do |x|
          x.register("004010", "HP", "835") { Stupidedi::Versions::FunctionalGroups::FortyTen::TransactionSetDefs::HP835 }
          x.register("005010", "HR", "276") { Stupidedi::Versions::FunctionalGroups::FiftyTen::TransactionSetDefs::HR276 }
          x.register("005010", "HN", "277") { Stupidedi::Versions::FunctionalGroups::FiftyTen::TransactionSetDefs::HN277 }
          x.register("005010", "BE", "834") { Stupidedi::Versions::FunctionalGroups::FiftyTen::TransactionSetDefs::BE834 }
          x.register("005010", "HP", "835") { Stupidedi::Versions::FunctionalGroups::FiftyTen::TransactionSetDefs::HP835 }
          x.register("005010", "HC", "837") { Stupidedi::Versions::FunctionalGroups::FiftyTen::TransactionSetDefs::HC837 }
          x.register("005010", "FA", "999") { Stupidedi::Versions::FunctionalGroups::FiftyTen::TransactionSetDefs::FA999 }

          x.register("004010X091A1", "HP", "835") { Stupidedi::Guides::FortyTen::X091A1::HP835 }
          x.register("005010X212",   "HR", "276") { Stupidedi::Guides::FiftyTen::X212::HR276  }
          x.register("005010X214",   "HN", "277") { Stupidedi::Guides::FiftyTen::X214::HN277  }
          x.register("005010X220",   "BE", "834") { Stupidedi::Guides::FiftyTen::X220::BE834  }
          x.register("005010X221",   "HP", "835") { Stupidedi::Guides::FiftyTen::X221::HP835  }
          x.register("005010X222",   "HC", "837") { Stupidedi::Guides::FiftyTen::X222::HC837P }
          x.register("005010X223",   "HC", "837") { Stupidedi::Guides::FiftyTen::X223::HC837I }
          x.register("005010X223A3", "HC", "837") { Stupidedi::Guides::FiftyTen::X223A3::HC837I }
          x.register("005010X231",   "FA", "999") { Stupidedi::Guides::FiftyTen::X231::FA999  }
          x.register("005010X279",   "HS", "270") { Stupidedi::Guides::FiftyTen::X279::HS270  }
          x.register("005010X279",   "HB", "271") { Stupidedi::Guides::FiftyTen::X279::HB271  }

          x.register("005010X220A1", "BE", "834") { Stupidedi::Guides::FiftyTen::X220A1::BE834  }
          x.register("005010X221A1", "HP", "835") { Stupidedi::Guides::FiftyTen::X221A1::HP835  }
          x.register("005010X222A1", "HC", "837") { Stupidedi::Guides::FiftyTen::X222A1::HC837P }
          x.register("005010X231A1", "FA", "999") { Stupidedi::Guides::FiftyTen::X231A1::FA999  }
          x.register("005010X279A1", "HS", "270") { Stupidedi::Guides::FiftyTen::X279A1::HS270  }
          x.register("005010X279A1", "HB", "271") { Stupidedi::Guides::FiftyTen::X279A1::HB271  }
        end
      end
    end

    def contrib(base = default)
      base.customize do |c|
        c.transaction_set.customize do |x|
          x.register("004010", "PO", "850") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::PO850 }
          x.register("004010", "PR", "855") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::PR855 }
          x.register("004010", "OW", "940") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::OW940 }
          x.register("004010", "AR", "943") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::AR943 }
          x.register("004010", "RE", "944") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::RE944 }
          x.register("004010", "SW", "945") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::SW945 }
          x.register("004010", "SM", "204") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::SM204 }
          x.register("004010", "QM", "214") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::QM214 }
          x.register("004010", "IM", "210") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::IM210 }
          x.register("004010", "GF", "990") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::GF990 }
          x.register("004010", "SS", "862") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::SS862 }
          x.register("004010", "PS", "830") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::PS830 }
          x.register("004010", "SH", "856") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::SH856 }
          x.register("004010", "SQ", "866") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::SQ866 }
          x.register("004010", "FA", "997") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::FA997 }
          x.register("004010", "SC", "832") { Stupidedi::Contrib::FortyTen::TransactionSetDefs::SC832 }

          x.register("002001", "SH", "856") { Stupidedi::Contrib::TwoThousandOne::TransactionSetDefs::SH856 }
          x.register("002001", "PO", "830") { Stupidedi::Contrib::TwoThousandOne::TransactionSetDefs::PO830 }
          x.register("002001", "FA", "997") { Stupidedi::Contrib::TwoThousandOne::TransactionSetDefs::FA997 }

          x.register("003010", "IN", "810") { Stupidedi::Contrib::ThirtyTen::TransactionSetDefs::IN810 }
          x.register("003010", "RA", "820") { Stupidedi::Contrib::ThirtyTen::TransactionSetDefs::RA820 }
          x.register("003010", "PO", "850") { Stupidedi::Contrib::ThirtyTen::TransactionSetDefs::PO850 }
          x.register("003010", "PC", "860") { Stupidedi::Contrib::ThirtyTen::TransactionSetDefs::PC860 }
          x.register("003010", "PS", "830") { Stupidedi::Contrib::ThirtyTen::TransactionSetDefs::PS830 }

          x.register("003040", "WA", "142") { Stupidedi::Contrib::ThirtyForty::TransactionSetDefs::WA142 }

          x.register("003050", "PO", "850") { Stupidedi::Contrib::ThirtyFifty::TransactionSetDefs::PO850 }
        end
      end
    end

    # @endgroup
    ###########################################################################
  end

end
