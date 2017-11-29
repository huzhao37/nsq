PREFIX=/usr/local
DESTDIR=
GOFLAGS=
BINDIR=${PREFIX}/bin

BLDDIR = build
EXT=
ifeq (${GOOS},windows)
    EXT=.exe
endif

DCCMG=
ifeq (${DCC},true)
    DCCMG=internal/topic_migrate_manager/dcc_topic_migrate_guard.go
endif

APPS = nsqd nsqlookupd nsqadmin nsq_pubsub nsq_to_nsq nsq_to_file nsq_to_http nsq_tail nsq_stat to_nsq nsq_data_tool nsqlookupd_migrate_proxy
all: $(APPS)

$(BLDDIR)/nsqd:        $(wildcard apps/nsqd/*.go       nsqd/*.go nsqdserver/*.go consistence/*.go      internal/*/*.go)
$(BLDDIR)/nsqlookupd:  $(wildcard apps/nsqlookupd/*.go nsqlookupd/*.go consistence/*.go internal/*/*.go)
$(BLDDIR)/nsqadmin:    $(wildcard apps/nsqadmin/*.go   nsqadmin/*.go nsqadmin/templates/*.go internal/*/*.go)
$(BLDDIR)/nsq_pubsub:  $(wildcard apps/nsq_pubsub/*.go  internal/*/*.go)
$(BLDDIR)/nsq_to_nsq:  $(wildcard apps/nsq_to_nsq/*.go  internal/*/*.go)
$(BLDDIR)/nsq_to_file: $(wildcard apps/nsq_to_file/*.go internal/*/*.go)
$(BLDDIR)/nsq_to_http: $(wildcard apps/nsq_to_http/*.go internal/*/*.go)
$(BLDDIR)/nsq_tail:    $(wildcard apps/nsq_tail/*.go  internal/*/*.go)
$(BLDDIR)/nsq_stat:    $(wildcard apps/nsq_stat/*.go             internal/*/*.go)
$(BLDDIR)/to_nsq:      $(wildcard apps/to_nsq/*.go               internal/*/*.go)
$(BLDDIR)/nsq_data_tool:  $(wildcard apps/nsq_data_tool/*.go consistence/*.go nsqd/*.go internal/*/*.go)
$(BLDDIR)/nsqlookupd_migrate_proxy:  $(wildcard apps/nsqlookupd_migrate/*.go nsqd/*.go internal/nsqlookupd_migrate/*.go internal/topic_migrate_manager/topic_migrate_manager*.go)    internal/topic_migrate_manager/migrate_config.go    internal/topic_migrate_manager/migrate_config.go   ${DCCMG}


$(BLDDIR)/%:
	@mkdir -p $(dir $@)
	go build ${GOFLAGS} -o $@ ./apps/$*

$(APPS): %: $(BLDDIR)/%

clean:
	rm -fr $(BLDDIR)

.PHONY: install clean all
.PHONY: $(APPS)

install: $(APPS)
	install -m 755 -d ${DESTDIR}${BINDIR}
	for APP in $^ ; do install -m 755 ${BLDDIR}/$$APP ${DESTDIR}${BINDIR}/$$APP${EXT} ; done
