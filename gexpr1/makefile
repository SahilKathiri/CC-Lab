BINDIR = bin
SRCDIR = src
INCDIR = inc
OBJDIR = obj

SRCS = $(wildcard $(SRCDIR)/*.c)
OBJS = $(SRCS:$(SRCDIR)%.c=$(OBJDIR)%.o)
DEPS = $(OBJS:.o=.d)

CFLAGS = -I$(INCDIR)

TARGET	= $(BINDIR)/gexpr

$(TARGET): $(OBJS)
	$(CC) -o $@ $^ -g

-include $(DEPS)

$(OBJDIR)/%.o: $(SRCDIR)/%.c 
	$(CC) $(CFLAGS) -c $<  -o $@

$(OBJDIR)/%.d: $(SRCDIR)/%.c
	$(CPP) $(CFLAGS) $< -MM -MT $(@:.d=.o) >$@

.PHONY: clean

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: cleandep

cleandep:
	rm -f $(DEPS)
