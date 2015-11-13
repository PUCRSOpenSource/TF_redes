# Trabalho Final - Redes de Computadores I

* Daniel Amarante
* Matthias Nunes

Este trabalho trata de desenvolver um simulador de rede que execute os comandos de ping e traceroute em uma topologia préviamente descrita.O simulador deve apresentar na saída as mensagens enviadas pelos nós e roteadores da topologia conforme o formato estabelecido.

---

# Detalhes de Implementação

O simulador foi desenvolvido na linguagem de programação Ruby. Sua estrutura interna consiste de um grafo de roteadores e nodos que são ligados quando possuem redes em comum.

Ambos os nodos e roteadores possuem as mesmas funções principais, implementadas diferentemente, porém com o mesmo nome, para que possam ser chamadas independende se estivermos tratando de um roteador ou de um nodo. Existe uma função para enviar e uma função para receber cada uma das mensagens, por exemplo `send_arp_request` e `receive_arp_request`.

Além disso também existe uma função para enviar uma mensagem, que complementa estas outras. No caso para um nodo enviar uma mensagem a função é a seguinte:

```ruby
def send_message ip_dest, ttl
	# get networks
	dest_network = addr_to_network ip_dest, prefix
	my_network = addr_to_network ip, prefix

	# find next ip
	if dest_network == my_network
		destination = ip_dest
	else
		destination = gateway
	end

	# check arp table
	if !arp_table.has_key?(destination)
		send_arp_request destination
	end

	# send message
	send_icmp_request ip, ip_dest, arp_table[destination], ttl
end
```

---

# Descrição de como utilizar o simulador

Para utilizar o simulador é nescessário ter o Ruby instalado

O formato do arquivo de entrada deve ser como no exemplo fornecido:
```
#NODE
n1,00:00:00:00:00:01,192.168.0.2/24,192.168.0.1
n2,00:00:00:00:00:02,192.168.0.3/24,192.168.0.1
n3,00:00:00:00:00:03,192.168.1.2/24,192.168.1.1
n4,00:00:00:00:00:04,192.168.1.3/24,192.168.1.1
#ROUTER
r1,2,00:00:00:00:00:05,192.168.0.1/24,00:00:00:00:00:06,192.168.1.1/24
#ROUTERTABLE
r1,192.168.0.0/24,0.0.0.0,0
r1,192.168.1.0/24,0.0.0.0,1
```

Para executar o programa é nescessário usar o comando:

`$ ruby topoconfig.rb [arquivo.txt] [comando] [ping-origem] [ping-destino]`

---

# Limitações do simulador e dificuldades de implementação

O simulador não tem nenhuma limitação dentro dos requisitos pedidos no trabalho. No caso de o arquivo de entrada conter uma topologia com erros, por exemplo um nodo cujo gateway esteja em outra rede, o simulador não funcionará corretamente.

A maior dificuldade durante a implementação foi saber quando trabalhar com portas e quando trabalhar com roteadores, o fato de o roteador ter diversas portas com ips diferentes e o nodo ter apenas um ip tornou algumas coisas confusas.

# Exemplo de execução de ping e tracerout

Os exemplos serão executados sobre uma topologia mostrada em aula durante uma das aulas de implementação, ele utiliza 3 nodos e 3 roteadores. Segue a especificação no formato de entrada do programa:

```
#NODE
n1,00:00:00:00:00:01,192.168.0.2/27,192.168.0.1
n2,00:00:00:00:00:02,192.168.0.66/27,192.168.0.65
n3,00:00:00:00:00:03,192.168.0.162/27,192.168.0.161
#ROUTER
r1,3,00:00:00:00:00:11,192.168.0.1/27,00:00:00:00:00:A1,192.168.0.33/27,00:00:00:00:00:A6,192.168.0.98/27
r2,3,00:00:00:00:00:12,192.168.0.65/27,00:00:00:00:00:A3,192.168.0.129/27,00:00:00:00:00:A2,192.168.0.34/27
r3,3,00:00:00:00:00:13,192.168.0.161/27,00:00:00:00:00:A5,192.168.0.97/27,00:00:00:00:00:A4,192.168.0.130/27
#ROUTERTABLE
r1,192.168.0.0/27,0.0.0.0,0
r1,192.168.0.32/27,0.0.0.0,1
r1,192.168.0.96/27,0.0.0.0,2
r1,0.0.0.0/0,192.168.0.34,1
r2,192.168.0.64/27,0.0.0.0,0
r2,192.168.0.128/27,0.0.0.0,1
r2,192.168.0.32/27,0.0.0.0,2
r2,0.0.0.0/0,192.168.0.130,1
r3,192.168.0.160/27,0.0.0.0,0
r3,192.168.0.96/27,0.0.0.0,1
r3,192.168.0.128/27,0.0.0.0,2
r3,0.0.0.0/0,192.168.0.98,1
```

Seguem os resultados:

```
ruby topoconfig.rb input/in3 ping 192.168.0.2 192.168.0.162

ARP_REQUEST|00:00:00:00:00:01,FF:FF:FF:FF:FF:FF|192.168.0.2,192.168.0.1
ARP_REPLY|00:00:00:00:00:11,00:00:00:00:00:01|192.168.0.1,192.168.0.2
ICMP_ECHOREQUEST|00:00:00:00:00:01,00:00:00:00:00:11|192.168.0.2,192.168.0.162|8
ARP_REQUEST|00:00:00:00:00:A1,FF:FF:FF:FF:FF:FF|192.168.0.33,192.168.0.34
ARP_REPLY|00:00:00:00:00:A2,00:00:00:00:00:A1|192.168.0.34,192.168.0.33
ICMP_ECHOREQUEST|00:00:00:00:00:A1,00:00:00:00:00:A2|192.168.0.2,192.168.0.162|7
ARP_REQUEST|00:00:00:00:00:A3,FF:FF:FF:FF:FF:FF|192.168.0.129,192.168.0.130
ARP_REPLY|00:00:00:00:00:A4,00:00:00:00:00:A3|192.168.0.130,192.168.0.129
ICMP_ECHOREQUEST|00:00:00:00:00:A3,00:00:00:00:00:A4|192.168.0.2,192.168.0.162|6
ARP_REQUEST|00:00:00:00:00:13,FF:FF:FF:FF:FF:FF|192.168.0.161,192.168.0.162
ARP_REPLY|00:00:00:00:00:03,00:00:00:00:00:13|192.168.0.162,192.168.0.161
ICMP_ECHOREQUEST|00:00:00:00:00:13,00:00:00:00:00:03|192.168.0.2,192.168.0.162|5
ICMP_ECHOREPLY|00:00:00:00:00:03,00:00:00:00:00:13|192.168.0.162,192.168.0.2|8
ARP_REQUEST|00:00:00:00:00:A5,FF:FF:FF:FF:FF:FF|192.168.0.97,192.168.0.98
ARP_REPLY|00:00:00:00:00:A6,00:00:00:00:00:A5|192.168.0.98,192.168.0.97
ICMP_ECHOREPLY|00:00:00:00:00:A5,00:00:00:00:00:A6|192.168.0.162,192.168.0.2|7
ICMP_ECHOREPLY|00:00:00:00:00:11,00:00:00:00:00:01|192.168.0.162,192.168.0.2|6
```
```
ruby topoconfig.rb input/in3 traceroute 192.168.0.2 192.168.0.162

ARP_REQUEST|00:00:00:00:00:01,FF:FF:FF:FF:FF:FF|192.168.0.2,192.168.0.1
ARP_REPLY|00:00:00:00:00:11,00:00:00:00:00:01|192.168.0.1,192.168.0.2
ICMP_ECHOREQUEST|00:00:00:00:00:01,00:00:00:00:00:11|192.168.0.2,192.168.0.162|1
ICMP_TIMEEXCEEDED|00:00:00:00:00:11,00:00:00:00:00:01|192.168.0.1,192.168.0.2|8
ICMP_ECHOREQUEST|00:00:00:00:00:01,00:00:00:00:00:11|192.168.0.2,192.168.0.162|2
ARP_REQUEST|00:00:00:00:00:A1,FF:FF:FF:FF:FF:FF|192.168.0.33,192.168.0.34
ARP_REPLY|00:00:00:00:00:A2,00:00:00:00:00:A1|192.168.0.34,192.168.0.33
ICMP_ECHOREQUEST|00:00:00:00:00:A1,00:00:00:00:00:A2|192.168.0.2,192.168.0.162|1
ARP_REQUEST|00:00:00:00:00:A3,FF:FF:FF:FF:FF:FF|192.168.0.129,192.168.0.130
ARP_REPLY|00:00:00:00:00:A4,00:00:00:00:00:A3|192.168.0.130,192.168.0.129
ICMP_TIMEEXCEEDED|00:00:00:00:00:A3,00:00:00:00:00:A4|192.168.0.129,192.168.0.2|8
ARP_REQUEST|00:00:00:00:00:A5,FF:FF:FF:FF:FF:FF|192.168.0.97,192.168.0.98
ARP_REPLY|00:00:00:00:00:A6,00:00:00:00:00:A5|192.168.0.98,192.168.0.97
ICMP_TIMEEXCEEDED|00:00:00:00:00:A5,00:00:00:00:00:A6|192.168.0.129,192.168.0.2|7
ICMP_TIMEEXCEEDED|00:00:00:00:00:11,00:00:00:00:00:01|192.168.0.129,192.168.0.2|6
ICMP_ECHOREQUEST|00:00:00:00:00:01,00:00:00:00:00:11|192.168.0.2,192.168.0.162|3
ICMP_ECHOREQUEST|00:00:00:00:00:A1,00:00:00:00:00:A2|192.168.0.2,192.168.0.162|2
ICMP_ECHOREQUEST|00:00:00:00:00:A3,00:00:00:00:00:A4|192.168.0.2,192.168.0.162|1
ICMP_TIMEEXCEEDED|00:00:00:00:00:A5,00:00:00:00:00:A6|192.168.0.97,192.168.0.2|8
ICMP_TIMEEXCEEDED|00:00:00:00:00:11,00:00:00:00:00:01|192.168.0.97,192.168.0.2|7
ICMP_ECHOREQUEST|00:00:00:00:00:01,00:00:00:00:00:11|192.168.0.2,192.168.0.162|4
ICMP_ECHOREQUEST|00:00:00:00:00:A1,00:00:00:00:00:A2|192.168.0.2,192.168.0.162|3
ICMP_ECHOREQUEST|00:00:00:00:00:A3,00:00:00:00:00:A4|192.168.0.2,192.168.0.162|2
ARP_REQUEST|00:00:00:00:00:13,FF:FF:FF:FF:FF:FF|192.168.0.161,192.168.0.162
ARP_REPLY|00:00:00:00:00:03,00:00:00:00:00:13|192.168.0.162,192.168.0.161
ICMP_ECHOREQUEST|00:00:00:00:00:13,00:00:00:00:00:03|192.168.0.2,192.168.0.162|1
ICMP_ECHOREPLY|00:00:00:00:00:03,00:00:00:00:00:13|192.168.0.162,192.168.0.2|8
ICMP_ECHOREPLY|00:00:00:00:00:A5,00:00:00:00:00:A6|192.168.0.162,192.168.0.2|7
ICMP_ECHOREPLY|00:00:00:00:00:11,00:00:00:00:00:01|192.168.0.162,192.168.0.2|6
```

