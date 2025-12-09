module.exports = {
    extends: ['@commitlint/config-conventional'],

    // Disable strict rules so everyday commits are allowed
    rules: {
        'type-enum': [0],      // allow any type
        'subject-empty': [0],  // allow empty subject
        'header-max-length': [0], // no limit
    }
};
