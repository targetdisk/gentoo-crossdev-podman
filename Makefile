TARGET ?= powerpc-unknown-linux-musl

Dockerfile: Dockerfile.in
	sed 's/\[%TARGET%\]/'"$(TARGET)/g" < $< > Dockerfile

targets/$(TARGET):
	mkdir -p targets/$(TARGET)

target-dir: targets/$(TARGET)

image: Dockerfile targets/$(TARGET)
	podman build -v $(shell pwd)/targets/$(TARGET):/usr/$(TARGET) -t crossdev-$(TARGET) .

clean:
	rm -rf Dockerfile targets/*

PHONY: all target-dir image
