echo "redis-cli flushall"
redis-cli flushall
echo "bin/rails db:drop db:setup"
bin/rails db:drop db:setup
echo "bin/rails runner CKAN::V26::CKANOrgSyncWorker.new.perform"
bin/rails runner CKAN::V26::CKANOrgSyncWorker.new.perform
echo "bin/rails runner CKAN::V26::PackageSyncWorker.new.perform"
bin/rails runner CKAN::V26::PackageSyncWorker.new.perform
echo "bin/rails search:reindex"
bin/rails search:reindex
echo "bundle exec sidekiq"
bundle exec sidekiq
