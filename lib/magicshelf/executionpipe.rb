require 'magicshelf/exception'

module MagicShelf
  class ExecutionPipe
    class Procedure
      attr_accessor :command_obj, :proc, :proc_withblock, :map_params, :params
      def initialize
        @command_obj    = nil
        @proc           = nil
        @proc_withblock = nil
        @params         = nil
        @map_params     = nil #from previous procedure
      end
    end

    def initialize
      @procedures = []
    end

    def pipe(command_obj, **map_params, &block)
      procedure = Procedure.new()
      block.call(command_obj)
      procedure.command_obj = command_obj
      procedure.map_params = map_params
      @procedures.push(procedure)
      self
    end

    def enter(**map_params, &block)
      procedure = Procedure.new()
      procedure.proc_withblock = block
      procedure.map_params = map_params
      @procedures.push(procedure)
      self
    end

    def process(**map_params, &block)
      procedure = Procedure.new()
      procedure.proc = block
      procedure.map_params = map_params
      @procedures.push(procedure)
      self
    end

    def execute
      self.execute_(0)
    end
    
    def execute_(i_proc)
      procedure = @procedures[i_proc]
      previous_procedure = @procedures[i_proc-1]

      if procedure.nil?
        return
      end

      if not procedure.command_obj.nil?
        if not previous_procedure.nil?
          if not previous_procedure.command_obj.nil?
            procedure.map_params.each_pair do |param_key_recv, param_keys|
              param_keys.each do |param_key|
                procedure.command_obj.instance_variable_set('@'+param_key.to_s, previous_procedure.command_obj.instance_variable_get('@'+param_key_recv.to_s))
              end
            end
          else
            procedure.map_params.each_pair do |param_key_recv, param_keys|
              param_keys.each do |param_key|
                procedure.command_obj.instance_variable_set('@'+param_key.to_s, previous_procedure.params[param_key_recv])
              end
            end
          end
        end
        procedure.command_obj.enter {
          procedure.command_obj.process
          self.execute_(i_proc+1)
        }
      elsif not procedure.proc.nil? or not procedure.proc_withblock.nil?

        procedure.params = {}
        if not previous_procedure.command_obj.nil?
          procedure.map_params.each_pair do |param_key_recv, param_keys|
            param_keys.each do |param_key|
              procedure.params[param_key] = previous_procedure.command_obj.instance_variable_get('@'+param_key_recv.to_s)
            end
          end
        else
          procedure.map_params.each_pair do |param_key_recv, param_keys|
            param_keys.each do |param_key|
              procedure.params[param_key] = previous_procedure.params[param_key_recv]
            end
          end
        end

        if not procedure.proc.nil?
          procedure.proc.call(procedure.params)
          self.execute_(i_proc+1)
        else
          procedure.proc_withblock.call(procedure.params) do
            self.execute_(i_proc+1)
          end
        end
      end
    end
  end
end
