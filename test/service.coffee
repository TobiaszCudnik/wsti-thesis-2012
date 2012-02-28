describe 'service', ->
	describe 'output', ->
	describe 'input', ->
	describe 'data', ->
		it 'should have signatures', ->
			no.should.be.ok
	describe 'flow', ->


describe 'component foo', ->
	obj = null
	beforeEach ->
		class Klass
			met1: (num) -> num*2
			met2: -> @met1 5
		obj = Klass
	it 'should call met1 when met2 called', ->
		sinon.stub obj
		obj.met2.restore()
		obj.met2()
		obj.met1.calledWith(5).should.be.ok()