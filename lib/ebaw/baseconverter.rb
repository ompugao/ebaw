require 'ebaw/exception'

module Ebaw
  class BaseConverter
    attr_accessor :next_converter
    
    def initialize
      @_binded_params = {}
      @_transfered_params = []
      yield self
      self
    end
      
    def bind_param(param_key, piped_param_key)
      @_binded_params[param_key.to_sym] = piped_param_key.to_sym
    end

    def transfer_param(param_key)
      @_transfered_params += [param_key.to_sym]
    end

    def enter(piped_params,&block)
      #raise Ebaw::Error.new("function enter is not defined.\n if you do not want to do anything, just call 'yield'")
      block.call(piped_params)
    end

    def process(entered_params)
      #raise Ebaw::Error.new("function execute is not defined")
      return entered_params
    end

    def pipe(converter)
      last_converter = self
      while !(last_converter.next_converter.nil?)
        last_converter = last_converter.next_converter
      end
      last_converter.next_converter = converter
      self
    end

    def execute(piped_params = {})
      ret = nil

      @_binded_params.each_pair do |param_key, piped_param_key| 
        self.instance_variable_set("@"+param_key.to_s, piped_params[piped_param_key])
      end

      self.enter(piped_params) do
        processed_params = self.process(piped_params)

        @_transfered_params.each do |param_key|
          processed_params[param_key] = self.instance_variable_get("@"+param_key.to_s)
        end

        ret = (@next_converter.nil? ?  processed_params : @next_converter.execute(processed_params))
      end
      ret
    end

  end
end
