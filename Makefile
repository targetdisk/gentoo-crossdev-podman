TARGET ?= powerpc-unknown-linux-musl

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

PHONY: all
