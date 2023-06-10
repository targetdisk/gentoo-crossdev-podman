TARGET ?= powerpc-unknown-linux-musl
OPEN ?= xdg-open

all: targets/.$(TARGET)

Dockerfile: Dockerfile.in
	sed 's/\[%TARGET%\]/'"$(TARGET)/g" < $< > Dockerfile

targets/$(TARGET):
	mkdir -p targets/$(TARGET)

targets/.$(TARGET): Dockerfile targets/$(TARGET)
	podman build -v $(PWD)/targets/$(TARGET):/usr/$(TARGET) -t crossdev-$(TARGET) .
	touch targets/.$(TARGET)

shell: targets/.$(TARGET)
	-@podman run -it -v $(PWD)/targets/$(TARGET):/usr/$(TARGET) crossdev-$(TARGET):latest /bin/bash

clean:
	rm -rf Dockerfile targets/*

pub.css:
	wget https://github.com/manuelp/pandoc-stylesheet/raw/acac36b976966f76544176161ba826d519b6f40c/pub.css

README: pub.css # Requires Pandoc to be installed
	pandoc README.md -s -c pub.css -o README.html
	$(OPEN) README.html

PHONY: all
