

$(SOCBLOX)/objs/$(PLATFORM) : 
	mkdir -p $@
	
$(SOCBLOX)/libs/$(PLATFORM) : 
	mkdir -p $@
	
$(SOCBLOX_OBJDIR)/%.o : %.cpp
	if test ! -d $(SOCBLOX_OBJDIR); then mkdir -p $(SOCBLOX_OBJDIR); fi
	$(CXX) -c $(CXXFLAGS) -o $@ $^	

$(SOCBLOX_A23_OBJDIR)/%.o : %.cpp
	if test ! -d $(SOCBLOX_A23_OBJDIR); then mkdir -p $(SOCBLOX_A23_OBJDIR); fi
	$(A23_CXX) -c $(A23_CXXFLAGS) $(CXXFLAGS) -o $@ $^

$(SOCBLOX_A23_LIBDIR)/%.a : 
	if test ! -d $(SOCBLOX_A23_LIBDIR); then mkdir -p $(SOCBLOX_A23_LIBDIR); fi
	rm -f $@
	$(A23_AR) vcq $@ $^

# Common link rule for shared libraries
$(SOCBLOX_LIBDIR)/%.so :
	if test ! -d $(SOCBLOX_LIBDIR); then mkdir -p $(SOCBLOX_LIBDIR); fi
	echo "COMMON LINK"
	$(LINK) -o $@ $(DLLOUT) $(filter-out %.so, $^) \
		$(foreach l,$(filter %.so, $^), -L$(dir $(l)) -l$(subst lib,,$(basename $(notdir $(l)))))

		