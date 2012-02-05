<?php
// $Id: views_handler_field_jskitcomments_widget.inc,v 1.1.2.2 2010/02/21 09:51:27 rehos Exp $
/**
 * Field handler to present a JS-Kit Echo Comments Widget for the node.
 */
class views_handler_field_jskitcomments_widget extends views_handler_field {
  function construct() {
    parent::construct();
    $this->additional_fields['nid'] = 'nid';
    $this->additional_fields['tnid'] = 'tnid';
    $this->additional_fields['type'] = 'type';
  }
  
  /**
   * Determine if this field can allow advanced rendering.
   *
   * Fields can set this to FALSE if they do not wish to allow
   * token based rewriting or link-making.
   */
  function allow_advanced_render() {
    return FALSE;
  }
  
  /**
   * Provide extra data to the administration form
   */
  function admin_summary() {
    return parent::admin_summary()."({$this->options['paginate']})";
  }

  
  function option_definition() {
    $options = parent::option_definition();

    $options['paginate'] = array('Paginate' => variable_get('jskitcomments_paginate', 0));

    return $options;
  }

  function options_form(&$form, &$form_state) {
    parent::options_form($form, $form_state);
    $form['paginate'] = array(
      '#type' => 'textfield',
      '#title' => t('Paginate'),
      '#size' => 3,
      '#maxlength' => 3,
      '#description' => t('You can break long lists of comments into multiple pages by specifying the number of comments per page. Otherwise leave it blank.'),
      '#default_value' => $this->options['paginate'],
    ); 
   // unset($form['alter']['make_link']);
  }

  function query() {
    $this->ensure_my_table();
    $this->add_additional_fields();
  }

  function render($values) {
    $node = new stdClass();
    $node->nid = $values->{$this->aliases['nid']};
    $node->tnid = $values->{$this->aliases['tnid']};
    $node->type = $values->{$this->aliases['type']};
    $types = variable_get('jskitcomments_nodetypes', array());
    return (empty($types[$node->type])) ? NULL :  jskitcomments_script($node, 'jskitcomments_views_field_widget', FALSE, $this->options['paginate']);
  }
}
