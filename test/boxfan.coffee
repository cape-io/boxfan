fs = require 'fs'
yaml = require 'js-yaml'
_ = require 'lodash'
should = require('chai').should()
boxfan = require('../boxfan')

data = yaml.safeLoad(fs.readFileSync(__dirname+'/data.yaml'))

describe 'boxfan', () ->
  it 'Returns only entries that match the filter.must object.', () ->
    filter =
      must:
        name: 'tim'
    res_arr = boxfan(data.simple_array, filter)
    res_arr.length.should.equal(2)
    res_arr.should.have.deep.property('[0].id', 3)
    res_arr.should.have.deep.property('[1].id', 6)

  it 'Return entries that have a value in the filter.should array.', () ->
    filter =
      should:
        name: ['tim', 'kai']
    res_arr = boxfan(data.simple_array, filter)
    res_arr.length.should.equal(3)
    res_arr.should.have.deep.property('[0].id', 1)
    res_arr.should.have.deep.property('[1].id', 3)
    res_arr.should.have.deep.property('[2].id', 6)

  it 'Return entries that do not have properties defined in filter.must_not.', () ->
    filter =
      must_not:
        name: 'kai'
        color: 'green'
        id: 5
    res_arr = boxfan(data.simple_array, filter)
    res_arr.length.should.equal(2)
    res_arr.should.have.deep.property('[0].id', 3)
    res_arr.should.have.deep.property('[1].id', 4)

  it 'Returns nothing if trying to search against a field no item has.', () ->
    filter =
      must:
        cow: 'bessy'
    res = boxfan(data.simple_array, filter).should.eql([])
