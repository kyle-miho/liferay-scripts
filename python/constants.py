VIRTUAL_HOST = 'localhost'
port = '8080'

## layoutTemplates

class LayoutTemplate:
    def __init__(self, id, columns):
        self.id = id
        self.columns = columns


layoutTemplates = {
    LayoutTemplate('1_column', 1),
    LayoutTemplate('2_columns_i', 2),
    LayoutTemplate('2_columns_ii', 2),
    LayoutTemplate('2_columns_iii', 2),
    LayoutTemplate('3_columns', 3),
    LayoutTemplate('1_2_columns_i', 3),
    LayoutTemplate('1_2_columns_ii', 3),
    LayoutTemplate('1_2_1_columns_i', 4),
    LayoutTemplate('1_2_1_columns_ii', 4),
    LayoutTemplate('1_3_1_columns', 5),
    LayoutTemplate('1_3_2_columns', 6),
    LayoutTemplate('2_1_2_columns', 5),
    LayoutTemplate('2_2_columns', 4),
    LayoutTemplate('3_2_3_columns', 8)}

#widgets

class Widget:
    def __init__(self,portletId,repeatable):
        self.portletId = portletId
        self.repeatable = repeatable

widgets = {
    Widget('com_liferay_asset_publisher_web_portlet_AssetPublisherPortlet', True),
    Widget('com_liferay_blogs_web_portlet_BlogsPortlet', False),
    Widget('com_liferay_bookmarks_web_portlet_BookmarksPortlet', False),
    Widget('com_liferay_site_navigation_breadcrumb_web_portlet_SiteNavigationBreadcrumbPortlet', True),
    Widget('com_liferay_asset_categories_navigation_web_portlet_AssetCategoriesNavigationPortlet', True),
    Widget('com_liferay_document_library_web_portlet_DLPortlet', True),
    Widget('com_liferay_knowledge_base_web_portlet_ArticlePortlet', True),
    Widget('com_liferay_knowledge_base_web_portlet_DisplayPortlet', False),
    Widget('com_liferay_site_navigation_language_web_portlet_SiteNavigationLanguagePortlet', False),
    Widget('com_liferay_document_library_web_portlet_IGDisplayPortlet', True),
    Widget('com_liferay_message_boards_web_portlet_MBPortlet', False),
    Widget('com_liferay_site_my_sites_web_portlet_MySitesPortlet', False),
    Widget('com_liferay_site_navigation_menu_web_portlet_SiteNavigationMenuPortlet', True),
    Widget('com_liferay_asset_publisher_web_portlet_RelatedAssetsPortlet', True),
    Widget('com_liferay_rss_web_portlet_RSSPortlet', True),
    Widget('com_liferay_portal_search_web_search_results_portlet_SearchResultsPortlet', True),
    Widget('com_liferay_site_navigation_site_map_web_portlet_SiteNavigationSiteMapPortlet', True),
    Widget('com_liferay_site_navigation_directory_web_portlet_SitesDirectoryPortlet', True),
    Widget('com_liferay_asset_tags_navigation_web_portlet_AssetTagsNavigationPortlet', True),
    Widget('com_liferay_portal_search_web_type_facet_portlet_TypeFacetPortlet', True),
    Widget('com_liferay_journal_content_web_portlet_JournalContentPortlet', True),
    Widget('com_liferay_wiki_web_portlet_WikiPortlet', False)}