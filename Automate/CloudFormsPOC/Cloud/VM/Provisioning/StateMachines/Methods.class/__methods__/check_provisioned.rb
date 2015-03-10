#
# Description: This method checks to see if the vm has been provisioned
#
# Get current provisioning status
task = $evm.root['miq_provision']
task_status = task['status']
result = task.status

$evm.log('info', "ProvisionCheck returned <#{result}> for state <#{task.state}> and status <#{task_status}>")

case result
when 'error'
  $evm.root['ae_result'] = 'error'
  reason = $evm.root['miq_provision'].message
  reason = reason[7..-1] if reason[0..6] == 'Error: '
  $evm.root['ae_reason'] = reason
when 'retry'
  $evm.root['ae_result']         = 'retry'
  $evm.root['ae_retry_interval'] = '30.seconds'
when 'ok'
  # Bump State
  $evm.root['ae_result'] = 'ok'
end