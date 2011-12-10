describe 'connection-graph', ->
  describe '#save()', ->
    it 'should save without error', (done) ->
      user = new User 'Luna'
      user.save (err) ->
        if err
	        throw err;
        done()