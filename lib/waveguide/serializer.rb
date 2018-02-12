module Waveguide
  class Serializer

    attr_reader :object, :scope

    def initialize(object, scope = nil)
      @object = object
      @scope = scope
    end

    def as_json
      self.class.attributes_to_serialize ||= []
      self.class.conditional_attributes ||= []
      self.class.serializer_methods ||= {}

      output = {}

      self.class.attributes_to_serialize.each do |key|
        output[key] = self.send(key)
      end

      self.class.conditional_attributes.each do |key|
        output[key] = self.send(key) if self.send("include_#{key}?")
      end

      output
    end

    class << self

      attr_accessor :attributes_to_serialize,
                    :conditional_attributes,
                    :serializer_methods

      def inherited(base)
        super
        base.attributes_to_serialize = (attributes_to_serialize || []).dup
        base.conditional_attributes = (conditional_attributes || []).dup
        base.serializer_methods = (serializer_methods || {}).dup

        (self.serializer_methods || {}).each do |key, block|
          base.send(:define_method, key, &block)
        end
      end

      def add_attribute(attr_name)
        return if self.conditional_attributes.include?(attr_name)

        self.attributes_to_serialize ||= []
        self.attributes_to_serialize << attr_name
        self.attributes_to_serialize.uniq!
      end

      def add_conditional_attribute(attr_name)
        self.conditional_attributes ||= []
        self.conditional_attributes << attr_name
        self.conditional_attributes.uniq!

        self.attributes_to_serialize.delete(attr_name)
      end

      def define_serializer_method(name, &block)
        self.serializer_methods ||= {}
        self.serializer_methods[name] = block

        define_method(name, &block)
      end

      def attributes(*attr_names)
        attr_names.each do |attr_name|
          attribute(attr_name)
        end
      end

      def attribute(attr_name, &block)
        add_attribute(attr_name)

        if block.nil?
          define_serializer_method(attr_name) { object.send(attr_name) }
        else
          define_serializer_method(attr_name, &block)
        end
      end

      def has_one(relation_name, as: nil, serializer: nil)
        key = as || relation_name
        add_attribute(key)
        if serializer
          define_serializer_method(key) do
            serializer.new(object.send(relation_name), scope).as_json
          end
        end
      end

      def has_many(relation_name, as: nil, serializer: nil)
        key = as || relation_name
        add_attribute(key)
        if serializer
          define_serializer_method(key) do
            object.send(relation_name).map do |item|
              serializer.new(item, scope).as_json
            end
          end
        end
      end

      def include?(attr_name, &block)
        add_conditional_attribute(attr_name)
        define_serializer_method("include_#{attr_name}?", &block)
      end
    end
  end
end
