EBIN_DIR=ebin
SOURCE_DIR=src
INCLUDE_DIR=include
DOC_DIR=doc

#ERLC_FLAGS=-W0 -Ddebug +debug_info
ERLC_FLAGS=-W
ERLC=erlc -I $(INCLUDE_DIR) -o $(EBIN_DIR) $(ERLC_FLAGS)
ERL=erl -I -pa ebin -noshell -eval

ERLS=$(wildcard $(SOURCE_DIR)/*.erl)
BEAMS=$(ERLS:$(SOURCE_DIR)/%.erl=$(EBIN_DIR)/%.beam)

all: compile docs

compile: $(EBIN_DIR) ${BEAMS}

$(EBIN_DIR):
	mkdir -p $(EBIN_DIR)

$(EBIN_DIR)/%.beam: $(SOURCE_DIR)/%.erl
	$(ERLC) $<

docs:
	$(ERL) -noshell -run edoc file $(SOURCE_DIR)/leex.erl -run init stop
	$(ERL) -noshell -run edoc_run application "'Leex'" '"."' '[no_packages]'
	mv $(SOURCE_DIR)/*.html $(DOC_DIR)/

clean:
	rm -rf erl_crash.dump 
	rm -rf $(EBIN_DIR)/*.beam
	rm -rf $(DOC_DIR)/*.html