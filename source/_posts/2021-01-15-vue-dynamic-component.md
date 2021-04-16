---
title: vue-dynamic-component
layout: post
date: 2021-01-15 09:34:57
categories: Vue
tags: Vue
---

使用动态组件实现菜单加载逻辑，并通过 mixin 提取公用部分。

```vue
<template>
  <div>
    <component
      :is="item"
      v-for="(item, index) in components"
      :key="item + index"
      :ref="item"
    />
  </div>
</template>

<script>
import Vue from 'vue';
import { mapActions } from 'vuex';

export default {
  props: {
    components: {
      type: Array,
    },
  },
  created() {
    if (this.components && this.components.length > 0) {
      this.components.forEach(component => {
        Vue.component(component, resolve =>
          require([`@/views/map/dynamicComponents/${component}`], response => {
            response.default.mixins = response.default.mixins || [];
            response.default.mixins.push({
              created() {
                this.$store.dispatch('AddDynamicComponent', {
                  name: component,
                  handleClose: this.handleClose,
                });
              },
            });
            resolve(response);
          }, () => {
            console.error(`未找到 @/views/map/dynamicComponents/${component}`);
          })
        );
      });
    }
  },
  methods: {
    ...mapActions(['AddDynamicComponent']),
  },
};
</script>
```
