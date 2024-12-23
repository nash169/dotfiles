user_pref("extensions.zotero.fileHandler.pdf", "/bin/zathura");
user_pref("extensions.zotero.groups.copyAnnotations", false);
user_pref("extensions.zotero.groups.copyChildFileAttachments", false);
user_pref("extensions.zotero.groups.copyChildLinks", false);
user_pref("extensions.zotero.sync.storage.groups.enabled", false);
user_pref("extensions.zotero.attachmentRenameTemplate", "{{ creators editors max=\"1\" case=\"lower\" suffix=\"_\" replaceFrom=\"\\s+\" replaceTo=\"_\" regexOpts=\"g\" }}{{ year suffix=\"_\" }}{{ title truncate=\"100\" case=\"lower\"  replaceFrom=\"\\s+\" replaceTo=\"_\" regexOpts=\"g\"}}");
user_pref("extensions.zotero.translators.better-bibtex.citekeyFormat", "auth.lower+\"_\"+shorttitle(1,0).lower+\"_\"+year");
user_pref("extensions.zotero.translators.better-bibtex.citekeyFormatEditing", "auth.lower+\"_\"+shorttitle(1,0).lower+\"_\"+year");
user_pref("extensions.zotero.zoterotag.rules", "[{\"id\":1,\"tags\":[\"/unread\"],\"untags\":[],\"group\":\"3\",\"actions\":[{\"event\":\"add\",\"operation\":\"add\",\"description\":\"add tags when creating new item\"}]},{\"id\":2,\"tags\":[\"/unread\"],\"untags\":[],\"group\":\"3\",\"actions\":[{\"event\":\"open\",\"operation\":\"remove\",\"description\":\"remove tags when opening item\"}]},{\"id\":3,\"tags\":[\"/reading\"],\"untags\":[],\"group\":\"1\",\"actions\":[{\"event\":\"annotation add\",\"operation\":\"add\",\"description\":\"add tags when creating annotation\"}]},{\"id\":4,\"tags\":[\"/toread\"],\"untags\":[],\"group\":\"2\",\"actions\":[]}]");
