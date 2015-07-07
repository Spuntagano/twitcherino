describe('mvUser', function(){
	beforeEach(module('twitcherinoApp'));

	describe('isAdmin', function(){
		it('Should return false if the roles array does not have an admin entry', inject(function(mvUser){
			var user = new mvUser;
			user.roles = ['not admin']
			expect(user.isAdmin()).to.be.falsey;
		}))

		it('Should return true if the roles array does have an admin entry', inject(function(mvUser){
			var user = new mvUser;
			user.roles = ['admin']
			expect(user.isAdmin()).to.be.true;
		}))
	})
})