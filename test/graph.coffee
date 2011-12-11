describe 'server', ->
  it 'should listen on a port', -> 
		no.should.eql yes 
  it 'should allow a client to connect', -> 
		no.should.eql yes
  it 'should send messages', -> 
		no.should.eql yes
  it 'should receive messages', -> 
		no.should.eql yes

describe 'client', ->
	it 'should connect to a port', -> 
		no.should.eql yes
	it 'should send messages', -> 
		no.should.eql yes
	it 'should receive messages', -> 
		no.should.eql yes
	it 'should reconnect if connection lost', -> 
		no.should.eql yes