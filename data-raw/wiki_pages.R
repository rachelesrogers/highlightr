## code to prepare `wiki_pages` dataset goes here

class_of_interest <- ".mw-content-ltr" ## ids are #id-name, classes are .class-name

editurl <- "https://en.wikipedia.org/w/index.php?title=Highlighter&action=history&offset=&limit=150"
editclass_of_interest <- ".mw-changeslist-date"

url_list1 <- editurl %>%
  read_html() %>%
  html_nodes(editclass_of_interest) %>%
  map(., list()) %>%
  tibble(node = .) %>%
  mutate(link = map_chr(node, html_attr, "href") %>% paste0("https://en.wikipedia.org", .))

editurl2 <- "https://en.wikipedia.org/w/index.php?title=Highlighter&action=history&dir=prev&limit=150"

url_list2 <- editurl2 %>%
  read_html() %>%
  html_nodes(editclass_of_interest) %>%
  map(., list()) %>%
  tibble(node = .) %>%
  mutate(link = map_chr(node, html_attr, "href") %>% paste0("https://en.wikipedia.org", .))

url_list <- rbind(url_list1, url_list2)

# Apply first block to every link in this block to get the full data set

wiki_pages <- data.frame(page_notes = rep(NA, dim(url_list)[1]))

for (i in 1:dim(url_list)[1]){

  wiki_list <-  url_list$link[i] %>%
    read_html() %>%
    html_node(class_of_interest) %>%
    html_children() %>%
    map(., list()) %>%
    tibble(node = .) %>%
    mutate(type = map_chr(node, html_name)) %>%
    filter(type == "p") %>%
    mutate(text = map_chr(node, html_text)) %>%
    mutate(cleantext = str_remove_all(text, "\\[.*?\\]") %>% str_trim()) %>%
    plyr::summarise(cleantext = paste(cleantext, collapse = "\n"))

  wiki_pages$page_notes[i] <- wiki_list$cleantext[1]

}



usethis::use_data(wiki_pages, overwrite = TRUE)
