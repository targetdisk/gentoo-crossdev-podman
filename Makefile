TARGET ?= powerpc-unknown-linux-musl
OPEN ?= xdg-open
EXTRA_PODMAN_FLAGS ?=

all: targets/.$(TARGET)

Dockerfile: Dockerfile.in
	sed 's/\[%TARGET%\]/'"$(TARGET)/g" < $< > Dockerfile

toolchain-scripts/$(TARGET).cmake: toolchain.cmake.in
	sed 's/\[%TARGET%\]/'"$(TARGET)/g" < $< > toolchain-scripts/$(TARGET).cmake

targets/$(TARGET):
	mkdir -p targets/$(TARGET)

targets/.$(TARGET): toolchain-scripts/$(TARGET).cmake Dockerfile targets/$(TARGET)
	podman build $(EXTRA_PODMAN_FLAGS) -v $(CURDIR)/targets/$(TARGET):/usr/$(TARGET) -t crossdev-$(TARGET) .
	touch targets/.$(TARGET)
	touch Dockerfile.in

shell: targets/.$(TARGET)
	-@podman run -it $(EXTRA_PODMAN_FLAGS) \
		-v $(CURDIR)/targets/$(TARGET):/usr/$(TARGET) \
		-v $(CURDIR)/toolchain-scripts:/opt/toolchain-scripts \
		crossdev-$(TARGET):latest /bin/bash

clean:
	rm -rf Dockerfile targets/* targets/.*

pub.css:
	wget https://github.com/manuelp/pandoc-stylesheet/raw/acac36b976966f76544176161ba826d519b6f40c/pub.css

README: pub.css # Requires Pandoc to be installed
	pandoc README.md -s -c pub.css -o README.html
	$(OPEN) README.html

.PHONY: Dockerfile all
