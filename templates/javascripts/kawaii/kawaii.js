Kawaii = {

  // Two spaces for tabs is good!
  tab_format : "  ",
  
  initialize : function() {
    this.tab_view = new YAHOO.widget.TabView('console_tabs');
    this.tab_number = 1
    this.wrap_results = true
    this.authenticity_token = $('kawaii_content').getAttribute('authenticity_token')
    
    this.snippets_enabled = ($('snippets') != null)
    
    // Load our snippets if we have a div for them
    if (this.snippets_enabled) {
      $('snippets').show()
      new Ajax.Request('/kawaii/snippets', {parameters:'authenticity_token=' + encodeURIComponent(this.authenticity_token), asynchronous:true, evalScripts:true})
    }

    this.add_tab()
                          
  },
  
  add_tab : function (name, value) {
    
    var whole_tab = new Element("div")
    var query_container = new Element("div", {'class' : 'query_container'})

    var close = new Element("input",
                            {'type': 'button', 
                             'value': 'Close Tab', 
                             'class': 'close_tab',
                             'onClick' : "Kawaii.close_tab(); return false;"})
    whole_tab.insert(new Element('div', {'class':'tab_header'}).insert(close))
    
    var query_id = "query_input_" + this.tab_number
    query_container.insert(new Element('div', {'class': 'text_area_container'}).insert(
      new Element('textarea', {'id': query_id, 'onkeypress': "Kawaii.text_area_keypress(event);", 'tab_number':this.tab_number}).update(value))
    )

    query_container.insert(new Element("input", 
                                        {'type': 'button', 
                                         'value': 'Execute', 
                                         'class': 'execute',
                                         'onClick' : "Kawaii.execute(" + this.tab_number + "); return false;"}))
    query_container.insert(new Element('span', {'class':'keyboard_shortcut'}).update("Ctrl-Enter"))

    if (this.snippets_enabled) {
     query_container.insert(new Element("input", 
                                         {'type': 'button', 
                                          'value': 'Save Snippet', 
                                          'class': 'save_query',
                                          'onClick' : "Kawaii.save_query(" + this.tab_number + "); return false;"}))
    }
    
    query_container.insert(new Element('div', {'id': 'loading_results_' + this.tab_number, 'style': 'display:none'}).update("<h1 class='loading'>Loading...</h1>"))
    query_container.insert(new Element('div', {'id': 'results_' + this.tab_number, 'class': 'results'}))
    
    var html = whole_tab.insert(query_container).innerHTML


    var this_tab = new YAHOO.widget.Tab({ label: (name || "Rails Code"), content: html, active: true })
    this.tab_view.addTab( this_tab )
    this.tab_number++
    
    $('tab_container').show()
    $(query_id).focus()    
  },
  
  close_tab : function () {
      this.tab_view.removeTab(this.tab_view.get('activeTab'));   
      
      if (this.tab_view.get('tabs').length == 0) {
        $('tab_container').hide()
      }
      
  },
  
  with_query : function (tab_number, with_query_function) {
    var query = $('query_input_' + tab_number).value
    if (query.length == 0) {
      alert('Your snippet is blank!')
    } else {
      with_query_function(query)
    }
  },
  
  execute : function (tab_number) {
    var authenticity_token = this.authenticity_token
    this.with_query(tab_number, function (query) {
      $('loading_results_' + tab_number).show()
      new Ajax.Request('/kawaii/query', 
                       {asynchronous:true, 
                        evalScripts:true, 
                        parameters:{'query':query, 'tab_number': tab_number, 'authenticity_token': authenticity_token}})    
    })
  },
  
  save_query : function (tab_number) {
    var authenticity_token = this.authenticity_token
    this.with_query(tab_number, function (query) {
      
      snippet_name = prompt("Type in a short name for the snippet")
      $('saving_snippet').show()
      new Ajax.Request('/kawaii/save_query', 
                       {asynchronous:true, 
                        evalScripts:true, 
                        parameters:{'query':query, 'tab_number': tab_number, 'snippet_name': snippet_name, 'authenticity_token': authenticity_token}})      
    })
  },
  
  show_grid : function (tab_number, columns, schema, data) {

    // Let's use client side paging!
    var oConfigs = { 
            paginator: new YAHOO.widget.Paginator({rowsPerPage: 25}), 
            scrollable: true,
            width: "100%",
            initialRequest: "results=504" 
    };
        
    this.myDataSource = new YAHOO.util.DataSource(data); 
    this.myDataSource.responseType = YAHOO.util.DataSource.TYPE_JSARRAY; 
    this.myDataSource.responseSchema = { 
        fields: schema
    }; 
  
    winwidth=parseInt(document.all?document.body.clientwidth:window.innerwidth)
    winHeight=parseInt(document.all?document.body.clientHeight:window.innerHeight)
    
    this.myDataTable = new YAHOO.widget.DataTable("results_" + tab_number, 
            columns, this.myDataSource, oConfigs);    
    $('loading_results_' + tab_number).hide()              
  },
  
  show_string : function (tab_number, string) {

    var results_div = $('results_' + tab_number)
    
    var formatted = string.replace(/\n/g, "<br/>").replace(/ /g, "&nbsp;")
    
    results_div.update(new Element('div', {'class': 'text_container'}).update(
      new Element('div', {'class':'result_text' + (this.wrap_results ? '' : ' avoid_wrap'), 'id': 'text_result_' + tab_number}).update(formatted))
    )
    results_div.insert(new Element('input', {'type': 'checkbox', 
                                              'id': 'wrap_' + tab_number, 
                                              'onclick':'Kawaii.toggle_wrap_results(' + tab_number + ")", 
                                              'checked': (this.wrap_results ? 'true' : null)}))
    results_div.insert(new Element('label', {'for' : 'wrap_' + tab_number}).update("Wrap Text"))
    

    $('loading_results_' + tab_number).hide()
  },
  
  toggle_wrap_results : function(tab_number) {
    
    this.wrap_results = !this.wrap_results
    if (this.wrap_results == false) {
      $('text_result_' + tab_number).addClassName('avoid_wrap')
    } else {
      $('text_result_' + tab_number).removeClassName('avoid_wrap')
    }
  },
  
  
  text_area_keypress : function (evt) {
    var t = evt.target;
    var ss = t.selectionStart;
    var se = t.selectionEnd;

    var code;
    if (evt.keyCode) code = evt.keyCode;
    else if (evt.which) code = evt.which;
    
    // Ctrl+Return -> execute
    if (code == 13 && evt.ctrlKey) {
      this.execute(t.getAttribute('tab_number'))
      return true
    }
    
    // Thanks: http://ajaxian.com/archives/handling-tabs-in-textareas
    // Tab key - insert tab expansion
    if (evt.keyCode == 9) {
        evt.preventDefault();
        // Special case of multi line selection
        if (ss != se && t.value.slice(ss,se).indexOf("\n") != -1) {
            // In case selection was not of entire lines (e.g. selection begins in the middle of a line)
            // we ought to tab at the beginning as well as at the start of every following line.
            var pre = t.value.slice(0,ss);
            var sel = t.value.slice(ss,se).replace(/\n/g,"\n"+this.tab_format);
            var post = t.value.slice(se,t.value.length);
            t.value = pre.concat(this.tab_format).concat(sel).concat(post);
            t.selectionStart = ss + this.tab_format.length;
            t.selectionEnd = se + this.tab_format.length;
        }
        // "Normal" case (no selection or selection on one line only)
        else {
            t.value = t.value.slice(0,ss).concat(this.tab_format).concat(t.value.slice(ss,t.value.length));
            if (ss == se) {
                t.selectionStart = t.selectionEnd = ss + this.tab_format.length;
            }
            else {
                t.selectionStart = ss + this.tab_format.length;
                t.selectionEnd = se + this.tab_format.length;
            }
        }
    }
    // Backspace key - delete preceding tab expansion, if exists
   else if (evt.keyCode==8 && t.value.slice(ss - 4,ss) == this.tab_format) {
        evt.preventDefault();
        t.value = t.value.slice(0,ss - 4).concat(t.value.slice(ss,t.value.length));
        t.selectionStart = t.selectionEnd = ss - this.tab_format.length;
    }
    // Delete key - delete following tab expansion, if exists
    else if (evt.keyCode==46 && t.value.slice(se,se + 4) == this.tab_format) {
        evt.preventDefault();
        t.value = t.value.slice(0,ss).concat(t.value.slice(ss + 4,t.value.length));
        t.selectionStart = t.selectionEnd = ss;
    }
    // Left/right arrow keys - move across the tab in one go
    else if (evt.keyCode == 37 && t.value.slice(ss - 4,ss) == this.tab_format) {
        evt.preventDefault();
        t.selectionStart = t.selectionEnd = ss - 4;
    }
    else if (evt.keyCode == 39 && t.value.slice(ss,ss + 4) == this.tab_format) {
        evt.preventDefault();
        t.selectionStart = t.selectionEnd = ss + 4;
    }
  }
  
}

YAHOO.util.Event.onDOMReady(function() { Kawaii.initialize() })
