test:
	@shellcheck ./src/*
	@bats src/test.bats
