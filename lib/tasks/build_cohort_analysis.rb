desc "Build cohorts and analysis"
task :build_cohort_analysis do
  Cohorts::build_and_analyze()
end

