require "helper"
require "fluent/plugin/filter_json_extractor.rb"

class JsonExtractorFilterTest < Test::Unit::TestCase
  def record_to_find = { key: 'val', key2: 'val2'}

  setup do
    Fluent::Test.setup
    @time = event_time
  end

  def create_driver(conf)
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::JsonExtractorFilter).configure(conf)
  end

  sub_test_case 'configure' do
    test 'test required parameters missing' do
      conf = %()
      assert_raise(Fluent::ConfigError) do
        create_driver(conf)
      end
    end

    test 'test required parameters ok' do
      val = "someKey"
      conf = %(
        extract_key   #{val}
      )
      d = create_driver(conf)
      assert_equal(val.length, d.instance.extract_key.length)
    end

    test 'test too many required parameters, last will be taken' do
      conf = %(
        extract_key   value
        extract_key   value2
      )
      
      create_driver(conf)
    end
  end

  sub_test_case 'filter' do    
    test 'extract single key' do
      conf = %(
        extract_key   extraction
      )
      
      driver = create_driver(conf)

      record = { extraction: record_to_find }
      
      driver.run do
        driver.feed("tag", @time, record)
      end

      assert_equal(0, driver.error_events.size)
      assert_equal(1, driver.filtered_records.size)
    end
  end


  sub_test_case 'filter' do
    test 'extract nested key' do
      conf = %(
        extract_key   extraction
      )
      
      driver = create_driver(conf)

      record = { 
        some_key: 'val', 
        nested: { 
          other_key: 'val3',
          extraction: record_to_find
          },
        nested2: {
          extraction: {
            super_key: 'super value'    
          }
        }
        }
      
      driver.run do
        driver.feed("tag", @time, record)
      end

      assert_equal(0, driver.error_events.size)
      assert_equal(1, driver.filtered_records.size)
      assert_equal(record_to_find, driver.filtered_records[0])
    end
  end
end
