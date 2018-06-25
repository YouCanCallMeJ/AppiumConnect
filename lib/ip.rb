class Ip
  def self.host_ip
    case Gem::Platform.local.os
    when 'darwin', 'linux'
      host_ip_ifconfig
    when 'mingw32'
      host_ip_ipconfig
    else
      '127.0.0.1'
    end
  end

  # Windows
  def self.host_ip_ipconfig
    /IPv4\sAddress[\.\s]*:\s[[0-9]*\.]*/
      .match(`ipconfig`)
      .to_s
      .split(' : ')[1]
  end

  # Mac and Ubuntu
  def self.host_ip_ifconfig
    ips = `ifconfig`.gsub('addr:', 'addr: ')
            .scan(/inet (?:addr: )?[[0-9]*\.]*/)
            .reject do |i|
              i.include?('127.0.0.1') || i.include?('172.17.0.1') || i.empty?
            end
    ips[0].split(' ')[-1]
  end
end
