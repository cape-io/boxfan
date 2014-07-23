_ = require 'lodash'
DJ = require 'dot-object'
dj = new DJ()

# Fields in the `values` object MUST match ALL `required` object fields.
matchAll = (values, required) ->
  match = true
  _.forEach required, (required_value, key) =>
    value_of_thing_to_check = dj.pick(key, values)
    if '*' == required_value
      if _.isEmpty value_of_thing_to_check
        match = false
        return false
    else if value_of_thing_to_check != required_value
      match = false
      return false
  return match

# Values object must contain any of required object.
matchAny = (values, required) ->
  match = false
  _.forEach required, (required_value, key) =>
    value_of_thing_to_check = dj.pick(key, values)
    # Thing to check must be one of the required values.
    if _.isArray required_value
      match = _.contains required_value, value_of_thing_to_check
    else
      match = (value_of_thing_to_check == required_value) or ('*' == required_value && not _.isEmpty value_of_thing_to_check)
    if match
      return false
  return match

hasFields = (values, required) ->
  if _.isString required
    return !_.isUndefined values[required]
  match = true
  if _.isArray required
    _.each required, (required_field_id) ->
      if _.isUndefined values[required_field_id]
        match = false
        return false
    return match
  else
    return false

filter = (values, filter_info) ->
  # Filter out anything that is not an object.
  unless _.isObject values
    return false
  filter_types = []
  if not (filter_info.must or filter_info.must_not or filter_info.should)
    filter_info = {must: filter_info}
    filter_types = ['must']
  else
    filter_types = _.keys filter_info

  if _.contains('must', filter_types) and _.isObject(filter_info.must) and not matchAll(values, filter_info.must)
    return false

  if _.contains('must_not', filter_types) and _.isObject(filter_info.must_not) and matchAny(values, filter_info.must_not)
    return false

  if _.contains('should', filter_types) and _.isObject(filter_info.should) and not matchAny(values, filter_info.should)
    return false

  return true


# Does this object match the filter info given?
module.exports = (values, filter_info) ->
  # When we get an array, filter it down.
  if _.isArray values
    return _.filter values, (item) =>
      return filter item, filter_info
  # Otherwise return a boolean value.
  else if _.isObject values
    return filter values, filter_info
  # Filter out anything that is not an object or array of objects.
  else
    return false
