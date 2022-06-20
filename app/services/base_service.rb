# frozen_string_literal: true

class BaseService
  extend Mixins::Service::Callable
  include ActiveModel::Validations

  def initialize(params = {})
    params.each { |k, v| instance_variable_set("@#{k}", v) }
  end

  def call
    pre_validate
    execute if valid?
    result_as_open_struct
  end

  private

  def execute
    raise(StandardError, 'Abstract method execute must be redefined')
  end

  def result_as_open_struct
    OpenStruct.new(data: result_data, errors: errors, valid?: valid?)
  end

  def result_data
    { success: true } if valid?
  end

  def pre_validate; end

  def delegate_errors(object)
    object.errors.each { |k, v| errors.add(k, v) }
  end

  def add_custom_error(msg, field: :base, **replaces)
    errors.add(field, format(I18n.t(msg, default: msg), replaces))
  end

  def valid?
    errors.blank?
  end

  def invalid?
    errors.any?
  end
end
