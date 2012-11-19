<?php
// $Id: jskitcomments.views.inc,v 1.1.2.1 2010/02/19 13:50:35 rehos Exp $
function jskitcomments_views_data_alter(&$data) {
  $data['node']['jskitcomments_count'] = array(
    'field' => array(
      'title' => t('JS-Kit Echo Comments Count'),
      'help' => t('The number of JS-Kit Echo Comments for the node.'),
      'handler' => 'views_handler_field_jskitcomments_count',
    ),
  );
  $data['node']['jskitcomments_widget'] = array(
    'field' => array(
      'title' => t('JS-Kit Echo Comments Widget'),
      'help' => t('JS-Kit Echo Comments Widget for the node.'),
      'handler' => 'views_handler_field_jskitcomments_widget',
    ),
  );
}

/**
 * Implementation of hook_views_handlers() to register all of the basic handlers
 * views uses.
 */
function jskitcomments_views_handlers() {
  return array(
    'handlers' => array(
      // field handlers
      'views_handler_field_jskitcomments_count' => array(
        'parent' => 'views_handler_field',
      ),
      'views_handler_field_jskitcomments_widget' => array(
        'parent' => 'views_handler_field',
      ),
	),
  );
}
