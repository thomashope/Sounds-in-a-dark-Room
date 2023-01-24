APP_NAME := SoundsInADarkRoom

.PHONY: debug release clean package upload

# launch a debug build
debug:
	love . --debug --skip-intro

# launch a release build
release:
	love .

# create a .love file
package:
	mkdir -p package
	zip -9 -r package/$(APP_NAME).love . -x@exclude.txt

# upload the love file to itch.io
upload:
	butler push package/$(APP_NAME).love thomas-hope/sounds-in-a-dark-room:love

clean:
	rm -rf package