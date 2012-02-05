<?php
// $Id: views_handler_field_jskitcomments_count.inc,v 1.1 2009/07/17 21:20:02 rehos Exp $
/**
 * Field handler to present a JS-Kit Comments Count for the node.
 */
class views_handler_field_jskitcomments_count extends views_handler_field {
  function construct() {
    parent::construct();
    $this->additional_fields['nid'] = 'nid';
    $this->additional_fields['tnid'] = 'tnid';
    $this->additional_fields['type'] = 'type';
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
	return jskitcomments_count_helper($node);
  }
}
