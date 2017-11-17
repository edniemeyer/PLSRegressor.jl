
@testset "Test Saving and Loading PLS2 Models" begin



	Xtr        = [1 2;2 4;3 6;6 12;7 14.0]
	Ytr        = [2 2;4 4;6 6;12 12;14 14.0]
	Xt         = [4 8;5 10.0]
	model1    = PLS.fit(Xtr,Ytr,nfactors=2)
	pred1     = PLS.transform(model1,Xt)

	PLS.save(model1)
	model2    = PLS.load()

	pred2     = PLS.transform(model2,Xt)
    rm(PLS.MODEL_FILENAME)
	@test all(pred1 .== pred2)


end

@testset "PLS2 Prediction Tests (in sample)" begin

	@testset "Single Column Prediction Test" begin

		X        = [1; 2; 3.0]
		Y        = [1 1; 2 2; 3 3.0]
		model    = PLS.fit(X,Y,nfactors=1)
		pred     = PLS.transform(model,X)

		@test isequal(round.(pred),[1 1; 2 2; 3 3.0])

	end

	@testset "Constant Values Prediction Tests (Ax + b) | A=0, b=1 " begin

		X        = [1 3;2 1;3 2.0]
		Y        = [1 1; 1 1; 1 1.0]
		try PLS.fit(X,Y,nfactors=2) catch @test true end

	end

	@testset "Linear Prediction Tests " begin


		X        = [1 2; 2 4; 4 6.0]
		Y        = [4 2;6 4;8 6.0]
		model    = PLS.fit(X,Y,nfactors=2)
		pred     = PLS.transform(model,X)
		@test isequal(round.(pred),[4 2;6 4;8 6.0])

		X           = [1 -2; 2 -4; 4 -6.0]
		Y           = [-4 -2;-6 -4;-8 -6.0]
		model       = PLS.fit(X,Y,nfactors=2)
		pred        = PLS.transform(model,X)
		@test isequal(round.(pred),[-4 -2;-6 -4;-8 -6.0])


	end


end

@testset "PLS2 Pediction Tests (out of sample)" begin


	@testset "Linear Prediction Tests (Ax + b) | A>0" begin


		Xtr        = [1 2;2 4;3 6;6 12;7 14.0]
		Ytr        = [2 2;4 4;6 6;12 12;14 14.0]
		Xt         = [4 8;5 10.0]
		model    = PLS.fit(Xtr,Ytr,nfactors=2)
		pred     = PLS.transform(model,Xt)
		@test isequal(round.(pred),[8 8;10 10.0])


		Xtr        = [1 2;2 4;3 6;6 12;7 14.0]
		Ytr        = [2 4;4 6;6 8;12 14;14 16.0]
		Xt         = [4 8;5 10.0]
		model    = PLS.fit(Xtr,Ytr,nfactors=2)
		pred     = PLS.transform(model,Xt)
		@test isequal(round.(pred),[8 10;10 12.0])


	end

	@testset "Linear Prediction Tests (Ax + b) | A<0" begin


		Xtr        = [1 -2;2 -4;3 -6;6 -12;7 -14.0]
		Ytr        = [2 -2;4 -4;6 -6;12 -12;14 -14.0]
		Xt         = [4 -8;5 -10.0]
		model    = PLS.fit(Xtr,Ytr,nfactors=2)
		pred     = PLS.transform(model,Xt)
		@test isequal(round.(pred),[8 -8;10 -10.0])


		Xtr        = [1 -2;2 -4;3 -6;6 -12;7 -14.0]
		Ytr        = [2 -4;4 -6;6 -8;12 -14;14 -16.0]
		Xt         = [4 -8;5 -10.0]
		model    = PLS.fit(Xtr,Ytr,nfactors=2)
		pred     = PLS.transform(model,Xt)
		@test isequal(round.(pred),[8 -10;10 -12.0])


	end


end;