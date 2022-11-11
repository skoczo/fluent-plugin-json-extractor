#
# Copyright 2022- skoczo
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "fluent/plugin/filter"

module Fluent
  module Plugin
    class JsonExtractorFilter < Fluent::Plugin::Filter
      Fluent::Plugin.register_filter("json_extractor", self)

      desc "Key name to extract"
      config_param :extract_key, :string, default: nil

      def configure(conf)
        super 
        
        if extract_key.nil?
          raise Fluent::ConfigError, "extract_key need to be set"
        end

        if extract_key.is_a?(Array)
          raise Fluent::ConfigError, "extract_key might be defined only once"
        end

        unless extract_key.is_a?(String)
          raise Fluent::ConfigError, "extract_key might be defined only once"
        end

      end

      def filter(_tag, _time, record)
        found = look_for_extraction(record)

        if found == nil
          raise Exception.new, "extract_key: '#{extract_key}' not found in data: #{record}"  
        end

        record = found
      end

      def look_for_extraction(record)
        if record.include?(extract_key)
          return record[extract_key]
        end

        record.each do |key, val|
          if val.is_a?(Hash)
            found = look_for_extraction(val)
            if found != nil
              return found
            end
          end
        end
      end
    end
  end
end
